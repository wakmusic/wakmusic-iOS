import TeamFeatureInterface
import NeedleFoundation
import UIKit
import TeamDomainInterface

public protocol TeamInfoDependency: Dependency {
    var fetchTeamListUseCase: any FetchTeamListUseCase { get }
}

public final class TeamInfoComponent: Component<TeamInfoDependency>, TeamInfoFactory {
    public func makeView() -> UIViewController {
        return TeamInfoViewController(
            viewModel: .init(
                fetchTeamListUseCase: dependency.fetchTeamListUseCase
            )
        )
    }
}
