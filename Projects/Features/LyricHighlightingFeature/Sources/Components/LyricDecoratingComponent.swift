import Foundation
import LyricDomainInterface
import LyricHighlightingFeatureInterface
import NeedleFoundation

public protocol LyricDecoratingDependency: Dependency {
    var fetchDecoratingBackgroundUseCase: any FetchDecoratingBackgroundUseCase { get }
}

public final class LyricDecoratingComponent: Component<LyricDecoratingDependency> {
    public func makeView(model: LyricHighlightingRequiredModel) -> LyricDecoratingViewController {
        let viewModel = LyricDecoratingViewModel(
            model: model,
            fetchDecoratingBackgroundUseCase: dependency.fetchDecoratingBackgroundUseCase
        )
        return LyricDecoratingViewController(viewModel: viewModel)
    }
}
