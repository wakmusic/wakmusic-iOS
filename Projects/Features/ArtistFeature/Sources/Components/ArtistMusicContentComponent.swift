import ArtistDomainInterface
import BaseFeature
import Foundation
import NeedleFoundation
import BaseFeatureInterface

public protocol ArtistMusicContentDependency: Dependency {
    var fetchArtistSongListUseCase: any FetchArtistSongListUseCase { get }
    var containSongsFactory: any ContainSongsFactory { get }
}

public final class ArtistMusicContentComponent: Component<ArtistMusicContentDependency> {
    public func makeView(
        type: ArtistSongSortType,
        model: ArtistListEntity?
    ) -> ArtistMusicContentViewController {
        return ArtistMusicContentViewController.viewController(
            viewModel: .init(
                type: type,
                model: model,
                fetchArtistSongListUseCase: dependency.fetchArtistSongListUseCase
            ),
            containSongsFactory: dependency.containSongsFactory
        )
    }
}
