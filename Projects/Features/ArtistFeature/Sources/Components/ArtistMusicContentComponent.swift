import ArtistDomainInterface
import BaseFeature
import BaseFeatureInterface
import Foundation
import NeedleFoundation

public protocol ArtistMusicContentDependency: Dependency {
    var fetchArtistSongListUseCase: any FetchArtistSongListUseCase { get }
    var containSongsFactory: any ContainSongsFactory { get }
    var songDetailPresenter: any SongDetailPresentable { get }
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
            containSongsFactory: dependency.containSongsFactory,
            songDetailPresenter: dependency.songDetailPresenter
        )
    }
}
