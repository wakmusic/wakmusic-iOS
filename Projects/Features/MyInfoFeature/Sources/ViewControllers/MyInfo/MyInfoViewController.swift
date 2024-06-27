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
import Then
import UIKit
import Utility

final class MyInfoViewController: BaseReactorViewController<MyInfoReactor>, EditSheetViewType {
    let myInfoView = MyInfoView()
    private var profilePopUpComponent: ProfilePopComponent!
    private var textPopUpFactory: TextPopUpFactory!
    private var multiPurposePopUpFactory: MultiPurposePopUpFactory!
    private var signInFactory: SignInFactory!
    private var faqFactory: FaqFactory! // 자주 묻는 질문
    private var noticeFactory: NoticeFactory! // 공지사항
    private var questionFactory: QuestionFactory! // 문의하기
    private var teamInfoFactory: TeamInfoFactory! // 팀 소개
    private var settingFactory: SettingFactory!
    private var fruitDrawFactory: FruitDrawFactory!

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
    }

    public static func viewController(
        reactor: MyInfoReactor,
        profilePopUpComponent: ProfilePopComponent,
        textPopUpFactory: TextPopUpFactory,
        multiPurposePopUpFactory: MultiPurposePopUpFactory,
        signInFactory: SignInFactory,
        faqFactory: FaqFactory,
        noticeFactory: NoticeFactory,
        questionFactory: QuestionFactory,
        teamInfoFactory: TeamInfoFactory,
        settingFactory: SettingFactory,
        fruitDrawFactory: FruitDrawFactory
    ) -> MyInfoViewController {
        let viewController = MyInfoViewController(reactor: reactor)
        viewController.profilePopUpComponent = profilePopUpComponent
        viewController.textPopUpFactory = textPopUpFactory
        viewController.multiPurposePopUpFactory = multiPurposePopUpFactory
        viewController.signInFactory = signInFactory
        viewController.faqFactory = faqFactory
        viewController.noticeFactory = noticeFactory
        viewController.questionFactory = questionFactory
        viewController.teamInfoFactory = teamInfoFactory
        viewController.settingFactory = settingFactory
        viewController.fruitDrawFactory = fruitDrawFactory
        return viewController
    }

    override func bindState(reactor: MyInfoReactor) {
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

        reactor.pulse(\.$loginButtonDidTap)
            .compactMap { $0 }
            .bind(with: self) { owner, _ in
                let vc = owner.signInFactory.makeView()
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

        reactor.pulse(\.$navigateType)
            .compactMap { $0 }
            .bind(with: self) { owner, navigate in
                switch navigate {
                case .draw:
                    let viewController = owner.fruitDrawFactory.makeView().wrapNavigationController
                    viewController.modalPresentationStyle = .fullScreen
                    owner.present(viewController, animated: true)
                case .like:
                    if reactor.currentState.isLoggedIn {
                        NotificationCenter.default.post(name: .movedTab, object: 4)
                        NotificationCenter.default.post(name: .movedStorageFavoriteTab, object: nil)
                    } else {
                        guard let vc = owner.textPopUpFactory.makeView(
                            text: "로그인이 필요한 서비스입니다.\n로그인 하시겠습니까?",
                            cancelButtonIsHidden: false,
                            confirmButtonText: nil,
                            cancelButtonText: nil,
                            completion: {
                                let loginVC = owner.signInFactory.makeView()
                                owner.present(loginVC, animated: true)
                            },
                            cancelCompletion: {}
                        ) as? TextPopupViewController else {
                            return
                        }
                        owner.showBottomSheet(content: vc)
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

        myInfoView.rx.likeNavigationButtonDidTap
            .map { MyInfoReactor.Action.likeNavigationDidTap }
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
            let vc = profilePopUpComponent.makeView()
            self.showEntryKitModal(content: vc, height: 352)
        case .nickname:
            guard let vc = multiPurposePopUpFactory
                .makeView(type: .nickname, key: "", completion: nil) as? MultiPurposePopupViewController
            else { return }
            self.showEntryKitModal(content: vc, height: 296)
        }
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
