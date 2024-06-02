import BaseFeature
import BaseFeatureInterface
import DesignSystem
import Foundation
import LogManager
import MyInfoFeatureInterface
import RxSwift
import SignInFeatureInterface
import SnapKit
import Then
import UIKit
import Utility

final class MyInfoViewController: BaseReactorViewController<MyInfoReactor> {
    let myInfoView = MyInfoView()
    private var textPopUpFactory: TextPopUpFactory!
    private var signInFactory: SignInFactory!
    private var faqComponent: FaqComponent! // 자주 묻는 질문
    private var noticeComponent: NoticeComponent! // 공지사항
    private var questionComponent: QuestionComponent! // 문의하기
    private var teamInfoComponent: TeamInfoComponent! // 팀 소개
    private var settingComponent: SettingComponent!

    override func configureNavigation() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func loadView() {
        view = myInfoView
    }

    public static func viewController(
        reactor: MyInfoReactor,
        textPopUpFactory: TextPopUpFactory,
        signInFactory: SignInFactory,
        faqComponent: FaqComponent,
        noticeComponent: NoticeComponent,
        questionComponent: QuestionComponent,
        teamInfoComponent: TeamInfoComponent,
        settingComponent: SettingComponent
    ) -> MyInfoViewController {
        let viewController = MyInfoViewController(reactor: reactor)
        viewController.textPopUpFactory = textPopUpFactory
        viewController.signInFactory = signInFactory
        viewController.faqComponent = faqComponent
        viewController.noticeComponent = noticeComponent
        viewController.questionComponent = questionComponent
        viewController.teamInfoComponent = teamInfoComponent
        viewController.settingComponent = settingComponent
        return viewController
    }

    override func bindState(reactor: MyInfoReactor) {
        reactor.state.map(\.isLoggedIn)
            .distinctUntilChanged()
            .bind(with: self) { owner, isLoggedIn in
                owner.myInfoView.updateIsHiddenLoginWarningView(isLoggedIn: isLoggedIn)
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
                print("로그인 버튼 눌림")
                let vc = owner.signInFactory.makeView()
                owner.present(vc, animated: true)
            }
            .disposed(by: disposeBag)

        reactor.pulse(\.$moreButtonDidTap)
            .compactMap { $0 }
            .bind { _ in
                print("더보기 버튼 눌림")
            }
            .disposed(by: disposeBag)

        reactor.pulse(\.$drawButtonDidTap)
            .compactMap { $0 }
            .bind(with: self) { owner, _ in
                print("뽑기 버튼 눌림")
            }
            .disposed(by: disposeBag)

        reactor.pulse(\.$likeNavigationDidTap)
            .compactMap { $0 }
            .bind(with: self) { owner, _ in
                print("좋아요 버튼 눌림")
                if reactor.currentState.isLoggedIn {
                    // TODO: 보관함 탭으로 이동, 좋아요 탭으로 이동
                    NotificationCenter.default.post(name: .movedTab, object: 4)
                    NotificationCenter.default.post(name: .movedStorageFavoriteTab, object: nil)
                } else {
                    // TODO: 로그인이 필요한 서비스입니다. 팝업
                }
            }
            .disposed(by: disposeBag)

        reactor.pulse(\.$faqNavigationDidTap)
            .compactMap { $0 }
            .bind(with: self) { owner, _ in
                print("자주믇는질문 버튼 눌림")
                let vc = owner.faqComponent.makeView()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)

        reactor.pulse(\.$notiNavigationDidTap)
            .compactMap { $0 }
            .bind(with: self) { owner, _ in
                print("공지사항 버튼 눌림")
                let vc = owner.noticeComponent.makeView()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)

        reactor.pulse(\.$mailNavigationDidTap)
            .compactMap { $0 }
            .bind(with: self) { owner, _ in
                print("문의하기 버튼 눌림")
                let vc = owner.questionComponent.makeView()
                vc.modalPresentationStyle = .overFullScreen
                owner.present(vc, animated: true)
            }
            .disposed(by: disposeBag)

        reactor.pulse(\.$teamNavigationDidTap)
            .compactMap { $0 }
            .bind(with: self) { owner, _ in
                print("팀소개 버튼 눌림")
                let vc = owner.teamInfoComponent.makeView()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)

        reactor.pulse(\.$settingNavigationDidTap)
            .compactMap { $0 }
            .bind(with: self) { owner, _ in
                print("설정 버튼 눌림")
                let vc = owner.settingComponent.makeView()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }

    override func bindAction(reactor: MyInfoReactor) {
        myInfoView.rx.loginButtonDidTap
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.asyncInstance)
            .map { MyInfoReactor.Action.loginButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        myInfoView.rx.moreButtonDidTap
            .map { MyInfoReactor.Action.moreButtonDidTap }
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
