import Foundation
import LyricHighlightingFeatureInterface
import NeedleFoundation
import SongsDomainInterface
import UIKit

public protocol LyricHighlightingDependency: Dependency {
    var fetchLyricsUseCase: any FetchLyricsUseCase { get }
    var lyricDecoratingComponent: LyricDecoratingComponent { get }
    var lyricHighlightingFactory: any LyricHighlightingFactory { get }
}

public final class LyricHighlightingComponent: Component<LyricHighlightingDependency>, LyricHighlightingFactory {
    public func makeView(model: LyricHighlightingRequiredModel) -> UIViewController {
        let viewModel = LyricHighlightingViewModel(model: model, fetchLyricsUseCase: dependency.fetchLyricsUseCase)
        return LyricHighlightingViewController(
            viewModel: viewModel,
            lyricDecoratingComponent: dependency.lyricDecoratingComponent
        )
    }
}
