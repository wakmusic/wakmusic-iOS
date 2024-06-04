import Foundation
import NeedleFoundation
import SongsDomainInterface

public protocol LyricHighlightingDependency: Dependency {
    var fetchLyricsUseCase: any FetchLyricsUseCase { get }
    var lyricDecoratingComponent: LyricDecoratingComponent { get }
}

public final class LyricHighlightingComponent: Component<LyricHighlightingDependency> {
    public func makeView(model: LyricHighlightingRequiredModel) -> LyricHighlightingViewController {
        let viewModel = LyricHighlightingViewModel(model: model, fetchLyricsUseCase: dependency.fetchLyricsUseCase)
        return LyricHighlightingViewController(
            viewModel: viewModel,
            lyricDecoratingComponent: dependency.lyricDecoratingComponent
        )
    }
}
