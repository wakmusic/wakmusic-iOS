import BaseFeature
import BaseFeatureInterface
import DesignSystem
import Foundation
import FruitDrawFeatureInterface
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
    private var textPopUpFactory: TextPopUpFactory!
    private var multiPurposePopUpFactory: MultiPurposePopupFactory!
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

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        hideEditSheet()
    }

    public static func viewController(
        reactor: MyInfoReactor,
        profilePopupFactory: ProfilePopupFactory,
        textPopUpFactory: TextPopUpFactory,
        multiPurposePopUpFactory: MultiPurposePopupFactory,
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
        viewController.textPopUpFactory = textPopUpFactory
        viewController.multiPurposePopUpFactory = multiPurposePopUpFactory
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
                        reactor.action.onNext(.requiredLogin)
                    }
                case .fruit:
                    if reactor.currentState.isLoggedIn {
                        let viewController = owner.fruitStorageFactory.makeView()
                        owner.navigationController?.pushViewController(viewController, animated: true)
                    } else {
                        reactor.action.onNext(.requiredLogin)
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
                case .login:
                    let vc = owner.textPopUpFactory.makeView(
                        text: "로그인이 필요한 서비스입니다.\n로그인 하시겠습니까?",
                        cancelButtonIsHidden: false,
                        confirmButtonText: nil,
                        cancelButtonText: nil,
                        completion: {
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
            .map { MyInfoReactor.Action.profileImageDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        myInfoView.rx.drawButtonDidTap
            .map { MyInfoReactor.Action.drawButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        myInfoView.rx.fruitNavigationButtonDidTap
            .map { MyInfoReactor.Action.fruitNavigationDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        myInfoView.rx.qnaNavigationButtonDidTap
            .map { MyInfoReactor.Action.faqNavigationDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        myInfoView.rx.notiNavigationButtonDidTap
            .map { MyInfoReactor.Action.notiNavigationDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        myInfoView.rx.mailNavigationButtonDidTap
            .map { MyInfoReactor.Action.mailNavigationDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        myInfoView.rx.teamNavigationButtonDidTap
            .map { MyInfoReactor.Action.teamNavigationDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        myInfoView.rx.settingNavigationButtonDidTap
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
            let vc = profilePopupFactory.makeView(
                completion: { [reactor] () in
                    reactor?.action.onNext(.completedSetProfile)
                }
            )
            let height: CGFloat = (ProfilePopupViewController.rowHeight * 2) + 10
            showBottomSheet(content: vc, size: .fixed(190 + height + SAFEAREA_BOTTOM_HEIGHT()))
        case .nickname:
            let vc = multiPurposePopUpFactory.makeView(
                type: .nickname,
                key: "",
                completion: { [reactor] text in
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
