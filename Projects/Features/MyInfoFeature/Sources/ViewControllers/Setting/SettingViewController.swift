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

final class SettingViewController: BaseReactorViewController<SettingReactor> {
    let settingView = SettingView()

    private var textPopUpFactory: TextPopUpFactory!
    private var signInFactory: SignInFactory!

    override func loadView() {
        view = settingView
    }

    public static func viewController(
        reactor: SettingReactor,
        textPopUpFactory: TextPopUpFactory
    ) -> SettingViewController {
        let viewController = SettingViewController(reactor: reactor)
        viewController.textPopUpFactory = textPopUpFactory
        return viewController
    }

    override func bindState(reactor: SettingReactor) {
        reactor.pulse(\.$dismissButtonDidTap)
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, _ in
                print("뒤로가기 버튼 눌림")
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        reactor.pulse(\.$withDrawButtonDidTap)
            .compactMap { $0 }
            .bind { _ in print("회원탈퇴 버튼 눌림") }
            .disposed(by: disposeBag)
    }

    override func bindAction(reactor: SettingReactor) {
        settingView.rx.dismissButtonDidTap
            .map { SettingReactor.Action.dismissButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        settingView.rx.withDrawButtonDidTap
            .map { SettingReactor.Action.withDrawButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        settingView.rx.notiNavigationButtonDidTap
            .map { SettingReactor.Action.notiNavigationDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        settingView.rx.termsNavigationButtonDidTap
            .map { SettingReactor.Action.termsNavigationDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        settingView.rx.privacyNavigationButtonDidTap
            .map { SettingReactor.Action.privacyNavigationDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        settingView.rx.openSourceNavigationButtonDidTap
            .map { SettingReactor.Action.openSourceNavigationDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        settingView.rx.removeCacheButtonDidTap
            .map { SettingReactor.Action.removeCacheButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        settingView.rx.versionInfoButtonDidTap
            .map { SettingReactor.Action.versionInfoButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
