import Foundation
import ImageDomainInterface
import LyricHighlightingFeatureInterface
import NeedleFoundation

public protocol LyricDecoratingDependency: Dependency {
    var fetchLyricDecoratingBackgroundUseCase: any FetchLyricDecoratingBackgroundUseCase { get }
}

public final class LyricDecoratingComponent: Component<LyricDecoratingDependency> {
    public func makeView(model: LyricHighlightingRequiredModel) -> LyricDecoratingViewController {
        let viewModel = LyricDecoratingViewModel(
            model: model,
            fetchLyricDecoratingBackgroundUseCase: dependency.fetchLyricDecoratingBackgroundUseCase
        )
        return LyricDecoratingViewController(viewModel: viewModel)
    }
}
