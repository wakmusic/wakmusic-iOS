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
    private let emptyView = UIView().then {
        $0.backgroundColor = .white
    }

    override func loadView() {
        view = emptyView
    }

    public static func viewController(
        reactor: TeamInfoReactor
    ) -> TeamInfoViewController {
        let viewController = TeamInfoViewController(reactor: reactor)
        return viewController
    }

    override func bindState(reactor: TeamInfoReactor) {}

    override func bindAction(reactor: TeamInfoReactor) {}
}
