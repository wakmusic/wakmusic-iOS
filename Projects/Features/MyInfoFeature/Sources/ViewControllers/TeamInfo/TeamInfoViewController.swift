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

final class TeamInfoViewController: BaseReactorViewController<TeamInfoReactor> {
    private let teamInfoView = TeamInfoView()

    override func loadView() {
        view = teamInfoView
    }

    public static func viewController(
        reactor: TeamInfoReactor
    ) -> TeamInfoViewController {
        let viewController = TeamInfoViewController(reactor: reactor)
        return viewController
    }

    override func bindState(reactor: TeamInfoReactor) {}

    override func bindAction(reactor: TeamInfoReactor) {
        teamInfoView.rx.dismissButtonDidTap.bind(with: self) { owner, _ in
            owner.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
    }
}
