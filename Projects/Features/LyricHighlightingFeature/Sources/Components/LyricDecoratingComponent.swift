import Foundation
import LyricHighlightingFeatureInterface
import NeedleFoundation

public protocol LyricDecoratingDependency: Dependency {}

public final class LyricDecoratingComponent: Component<LyricDecoratingDependency> {
    public func makeView(model: LyricHighlightingRequiredModel) -> LyricDecoratingViewController {
        let viewModel = LyricDecoratingViewModel(model: model)
        return LyricDecoratingViewController(viewModel: viewModel)
    }
}
