import BaseFeature
import BaseFeatureInterface
import DesignSystem
import Foundation
import FruitDrawFeatureInterface
import Localization
import LogManager
import MyInfoFeatureInterface
import RxSwift
import SignInFeatureInterface
import SnapKit
import TeamFeatureInterface
import Then
import UIKit
import Utility

final class MyInfoViewController: BaseReactorViewController<MyInfoReactor>, EditSheetViewType {
    let myInfoView = MyInfoView()
    private var profilePopupFactory: ProfilePopupFactory!
    private var textPopupFactory: TextPopupFactory!
    private var multiPurposePopupFactory: MultiPurposePopupFactory!
    private var signInFactory: SignInFactory!
    private var faqFactory: FaqFactory! // 자주 묻는 질문
    private var noticeFactory: NoticeFactory! // 공지사항
    private var questionFactory: QuestionFactory! // 문의하기
    private var teamInfoFactory: TeamInfoFactory! // 팀 소개
    private var settingFactory: SettingFactory!
    private var fruitDrawFactory: FruitDrawFactory!
    private var fruitStorageFactory: FruitStorageFactory!

    var editSheetView: EditSheetView!
    var bottomSheetView: BottomSheetView!

    override func configureNavigation() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func loadView() {
        view = myInfoView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        reactor?.action.onNext(.viewDidLoad)
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        LogManager.analytics(CommonAnalyticsLog.viewPage(pageName: .myPage))
    }

    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        hideEditSheet()
    }

    public static func viewController(
        reactor: MyInfoReactor,
        profilePopupFactory: ProfilePopupFactory,
        textPopupFactory: TextPopupFactory,
        multiPurposePopupFactory: MultiPurposePopupFactory,
        signInFactory: SignInFactory,
        faqFactory: FaqFactory,
        noticeFactory: NoticeFactory,
        questionFactory: QuestionFactory,
        teamInfoFactory: TeamInfoFactory,
        settingFactory: SettingFactory,
        fruitDrawFactory: FruitDrawFactory,
        fruitStorageFactory: FruitStorageFactory
    ) -> MyInfoViewController {
        let viewController = MyInfoViewController(reactor: reactor)
        viewController.profilePopupFactory = profilePopupFactory
        viewController.textPopupFactory = textPopupFactory
        viewController.multiPurposePopupFactory = multiPurposePopupFactory
        viewController.signInFactory = signInFactory
        viewController.faqFactory = faqFactory
        viewController.noticeFactory = noticeFactory
        viewController.questionFactory = questionFactory
        viewController.teamInfoFactory = teamInfoFactory
        viewController.settingFactory = settingFactory
        viewController.fruitDrawFactory = fruitDrawFactory
        viewController.fruitStorageFactory = fruitStorageFactory
        return viewController
    }

    override func bindState(reactor: MyInfoReactor) {
        reactor.pulse(\.$showToast)
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, message in
                owner.showToast(text: message, options: [.tabBar])
            })
            .disposed(by: disposeBag)

        reactor.state.map(\.isAllNoticesRead)
            .skip(1)
            .distinctUntilChanged()
            .bind(with: self) { owner, isAllNoticesRead in
                owner.myInfoView.newNotiIndicator.isHidden = isAllNoticesRead
            }
            .disposed(by: disposeBag)

        reactor.state.map(\.isLoggedIn)
            .distinctUntilChanged()
            .bind(with: self) { owner, isLoggedIn in
                owner.myInfoView.updateIsHiddenLoginWarningView(isLoggedIn: isLoggedIn)
            }
            .disposed(by: disposeBag)

        reactor.state.map(\.profileImage)
            .distinctUntilChanged()
            .bind(with: self) { owner, image in
                owner.myInfoView.profileView.updateProfileImage(image: image)
            }
            .disposed(by: disposeBag)

        reactor.state.map(\.nickname)
            .distinctUntilChanged()
            .bind(with: self) { owner, nickname in
                owner.myInfoView.profileView.updateNickName(nickname: nickname)
            }
            .disposed(by: disposeBag)

        reactor.state.map(\.platform)
            .distinctUntilChanged()
            .bind(with: self) { owner, platform in
                owner.myInfoView.profileView.updatePlatform(platform: platform)
            }
            .disposed(by: disposeBag)

        reactor.state.map(\.fruitCount)
            .distinctUntilChanged()
            .bind(with: self) { owner, count in
                owner.myInfoView.updateFruitCount(count: count)
            }
            .disposed(by: disposeBag)

        reactor.pulse(\.$loginButtonDidTap)
            .compactMap { $0 }
            .bind(with: self) { owner, _ in
                let log = CommonAnalyticsLog.clickLoginButton(entry: .mypage)
                LogManager.analytics(log)

                let vc = owner.signInFactory.makeView()
                vc.modalPresentationStyle = .fullScreen
                owner.present(vc, animated: true)
            }
            .disposed(by: disposeBag)

        reactor.pulse(\.$profileImageDidTap)
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, _ in
                owner.showEditSheet(in: owner.view, type: .profile)
                owner.editSheetView.delegate = owner
            })
            .disposed(by: disposeBag)

        reactor.pulse(\.$dismissEditSheet)
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, _ in
                owner.hideEditSheet()
            })
            .disposed(by: disposeBag)

        reactor.pulse(\.$navigateType)
            .compactMap { $0 }
            .bind(with: self) { owner, navigate in
                switch navigate {
                case .draw:
                    if reactor.currentState.isLoggedIn {
                        let viewController = owner.fruitDrawFactory.makeView(delegate: owner)
                        viewController.modalPresentationStyle = .fullScreen
                        owner.present(viewController, animated: true)
                    } else {
                        reactor.action.onNext(.requiredLogin(.fruitDraw))
                    }
                case .fruit:
                    if reactor.currentState.isLoggedIn {
                        let viewController = owner.fruitStorageFactory.makeView()
                        owner.navigationController?.pushViewController(viewController, animated: true)
                    } else {
                        reactor.action.onNext(.requiredLogin(.fruitStorage))
                    }
                case .faq:
                    let vc = owner.faqFactory.makeView()
                    owner.navigationController?.pushViewController(vc, animated: true)
                case .noti:
                    let vc = owner.noticeFactory.makeView()
                    owner.navigationController?.pushViewController(vc, animated: true)
                case .mail:
                    let vc = owner.questionFactory.makeView()
                    vc.modalPresentationStyle = .overFullScreen
                    owner.present(vc, animated: true)
                case .team:
                    let vc = owner.teamInfoFactory.makeView()
                    owner.navigationController?.pushViewController(vc, animated: true)
                case .setting:
                    let vc = owner.settingFactory.makeView()
                    owner.navigationController?.pushViewController(vc, animated: true)
                case let .login(entry):
                    let vc = owner.textPopupFactory.makeView(
                        text: LocalizationStrings.needLoginWarning,
                        cancelButtonIsHidden: false,
                        confirmButtonText: nil,
                        cancelButtonText: nil,
                        completion: {
                            switch entry {
                            case .fruitDraw:
                                let log = CommonAnalyticsLog.clickLoginButton(entry: .fruitDraw)
                                LogManager.analytics(log)
                            case .fruitStorage:
                                let log = CommonAnalyticsLog.clickLoginButton(entry: .fruitStorage)
                                LogManager.analytics(log)
                            default:
                                assertionFailure("예상치 못한 entry가 들어옴")
                                LogManager.printDebug("예상치 못한 entry가 들어옴")
                            }

                            let loginVC = owner.signInFactory.makeView()
                            loginVC.modalPresentationStyle = .fullScreen
                            owner.present(loginVC, animated: true)
                        },
                        cancelCompletion: {}
                    )
                    owner.showBottomSheet(content: vc)
                }
            }
            .disposed(by: disposeBag)
    }

    override func bindAction(reactor: MyInfoReactor) {
        myInfoView.rx.loginButtonDidTap
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.asyncInstance)
            .map { MyInfoReactor.Action.loginButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        myInfoView.rx.profileImageDidTap
            .do(onNext: { LogManager.analytics(MyInfoAnalyticsLog.clickProfileImage) })
            .map { MyInfoReactor.Action.profileImageDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        myInfoView.rx.fruitStorageButtonDidTap
            .do(onNext: { LogManager.analytics(MyInfoAnalyticsLog.clickFruitStorageButton) })
            .map { MyInfoReactor.Action.fruitNavigationDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        myInfoView.rx.drawButtonDidTap
            .do(onNext: { LogManager.analytics(MyInfoAnalyticsLog.clickFruitDrawEntryButton(location: .myPage)) })
            .map { MyInfoReactor.Action.drawButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        myInfoView.rx.fruitNavigationButtonDidTap
            .do(onNext: { LogManager.analytics(MyInfoAnalyticsLog.clickFruitStorageButton) })
            .map { MyInfoReactor.Action.fruitNavigationDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        #warning("자주묻는질문 qna -> faq 로 변경하기")
        myInfoView.rx.qnaNavigationButtonDidTap
            .do(onNext: { LogManager.analytics(MyInfoAnalyticsLog.clickFaqButton) })
            .map { MyInfoReactor.Action.faqNavigationDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        myInfoView.rx.notiNavigationButtonDidTap
            .do(onNext: { LogManager.analytics(MyInfoAnalyticsLog.clickNoticeButton) })
            .map { MyInfoReactor.Action.notiNavigationDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        #warning("문의하기 mail -> qna 로 변경하기")
        myInfoView.rx.mailNavigationButtonDidTap
            .do(onNext: { LogManager.analytics(MyInfoAnalyticsLog.clickInquiryButton) })
            .map { MyInfoReactor.Action.mailNavigationDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        myInfoView.rx.teamNavigationButtonDidTap
            .do(onNext: { LogManager.analytics(MyInfoAnalyticsLog.clickTeamButton) })
            .map { MyInfoReactor.Action.teamNavigationDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        myInfoView.rx.settingNavigationButtonDidTap
            .do(onNext: { LogManager.analytics(MyInfoAnalyticsLog.clickSettingButton) })
            .map { MyInfoReactor.Action.settingNavigationDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        myInfoView.rx.scrollViewDidTap
            .bind(with: self) { owner, _ in
                owner.hideEditSheet()
            }.disposed(by: disposeBag)
    }
}

extension MyInfoViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}

extension MyInfoViewController: EditSheetViewDelegate {
    func buttonTapped(type: EditSheetSelectType) {
        switch type {
        case .edit:
            break
        case .share:
            break
        case .profile:
            LogManager.analytics(MyInfoAnalyticsLog.clickProfileChangeButton)
            let vc = profilePopupFactory.makeView(
                completion: { [reactor] () in
                    LogManager.analytics(MyInfoAnalyticsLog.completeProfileChange)
                    reactor?.action.onNext(.completedSetProfile)
                }
            )
            let height: CGFloat = (ProfilePopupViewController.rowHeight * 2) + 10
            showBottomSheet(content: vc, size: .fixed(190 + height + SAFEAREA_BOTTOM_HEIGHT()))
        case .nickname:
            LogManager.analytics(MyInfoAnalyticsLog.clickNicknameChangeButton)
            let vc = multiPurposePopupFactory.makeView(
                type: .nickname,
                key: "",
                completion: { [reactor] text in
                    LogManager.analytics(MyInfoAnalyticsLog.completeNicknameChange)
                    reactor?.action.onNext(.changeNicknameButtonDidTap(text))
                }
            )
            showBottomSheet(content: vc, size: .fixed(296))
        }
        hideEditSheet()
    }
}

extension MyInfoViewController: EqualHandleTappedType {
    func equalHandleTapped() {
        let viewControllersCount: Int = self.navigationController?.viewControllers.count ?? 0
        if viewControllersCount > 1 {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}

extension MyInfoViewController: FruitDrawViewControllerDelegate {
    func completedFruitDraw(itemCount: Int) {
        reactor?.action.onNext(.completedFruitDraw)
    }
}
