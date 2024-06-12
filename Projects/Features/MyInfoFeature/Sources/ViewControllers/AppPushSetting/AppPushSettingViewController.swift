import BaseFeature
import BaseFeatureInterface
import DesignSystem
import Foundation
import LogManager
import MyInfoFeatureInterface
import RxSwift
import SnapKit
import Then
import UIKit
import Utility

final class AppPushSettingViewController: BaseReactorViewController<AppPushSettingReactor> {
    private let appPushSettingView = AppPushSettingView()

    override func loadView() {
        view = appPushSettingView
    }

    public static func viewController(
        reactor: AppPushSettingReactor
    ) -> AppPushSettingViewController {
        let viewController = AppPushSettingViewController(reactor: reactor)
        return viewController
    }

    override func bindState(reactor: AppPushSettingReactor) {}

    override func bindAction(reactor: AppPushSettingReactor) {
        appPushSettingView.rx.dismissButtonDidTap.bind(with: self) { owner, _ in
            owner.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
    }
}
