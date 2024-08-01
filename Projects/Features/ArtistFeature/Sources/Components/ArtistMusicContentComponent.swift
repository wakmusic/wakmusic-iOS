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
    var textPopUpFactory: any TextPopUpFactory { get }
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
            signInFactory: dependency.signInFactory,
            textPopupFactory: dependency.textPopUpFactory,
            songDetailPresenter: dependency.songDetailPresenter
        )
    }
}
