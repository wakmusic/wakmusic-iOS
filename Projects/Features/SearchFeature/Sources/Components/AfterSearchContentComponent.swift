
import BaseFeature
import Foundation
import NeedleFoundation
import BaseFeatureInterface

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
