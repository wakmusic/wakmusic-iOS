import ArtistDomainInterface
import BaseFeature
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import SignInFeatureInterface

public protocol ArtistMusicContentDependency: Dependency {
    var fetchArtistSongListUseCase: any FetchArtistSongListUseCase { get }
    var containSongsFactory: any ContainSongsFactory { get }
    var signInFactory: any SignInFactory { get }
    var textPopupFactory: any TextPopupFactory { get }
    var songDetailPresenter: any SongDetailPresentable { get }
}

@MainActor
public final class ArtistMusicContentComponent: Component<ArtistMusicContentDependency> {
    public func makeView(
        type: ArtistSongSortType,
        model: ArtistEntity?
    ) -> ArtistMusicContentViewController {
        return ArtistMusicContentViewController.viewController(
            viewModel: .init(
                type: type,
                model: model,
                fetchArtistSongListUseCase: dependency.fetchArtistSongListUseCase
            ),
            containSongsFactory: dependency.containSongsFactory,
            signInFactory: dependency.signInFactory,
            textPopupFactory: dependency.textPopupFactory,
            songDetailPresenter: dependency.songDetailPresenter
        )
    }
}
