
import BaseFeature
import BaseFeatureInterface
import Foundation
import NeedleFoundation

public final class AfterSearchContentComponent: Component<EmptyDependency> {
    public func makeView(
        type: TabPosition,
        dataSource: [SearchSectionModel]
    ) -> AfterSearchContentViewController {
        return AfterSearchContentViewController.viewController(
            viewModel: .init(
                type: type,
                dataSource: dataSource
            )
        )
    }
}
