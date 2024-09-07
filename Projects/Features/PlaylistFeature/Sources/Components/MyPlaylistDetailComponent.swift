import AuthDomainInterface
import BaseFeature
import BaseFeatureInterface
import NeedleFoundation
import PlaylistDomainInterface
import PlaylistFeatureInterface
import UIKit

public protocol MyPlaylistDetailDependency: Dependency {
    var fetchPlaylistDetailUseCase: any FetchPlaylistDetailUseCase { get }
    var updatePlaylistUseCase: any UpdatePlaylistUseCase { get }
    var updateTitleAndPrivateUseCase: any UpdateTitleAndPrivateUseCase { get }
    var removeSongsUseCase: any RemoveSongsUseCase { get }
    var uploadDefaultPlaylistImageUseCase: any UploadDefaultPlaylistImageUseCase { get }
    var logoutUseCase: any LogoutUseCase { get }
    var multiPurposePopupFactory: any MultiPurposePopupFactory { get }
    var containSongsFactory: any ContainSongsFactory { get }
    var playlistCoverOptionPopupFactory: any PlaylistCoverOptionPopupFactory { get }
    var checkPlaylistCoverFactory: any CheckPlaylistCoverFactory { get }
    var defaultPlaylistCoverFactory: any DefaultPlaylistCoverFactory { get }
    var requestCustomImageURLUseCase: any RequestCustomImageURLUseCase { get }
    var songDetailPresenter: any SongDetailPresentable { get }
    var textPopupFactory: any TextPopupFactory { get }
}

public final class MyPlaylistDetailComponent: Component<MyPlaylistDetailDependency>, MyPlaylistDetailFactory {
    public func makeView(key: String) -> UIViewController {
        return MyPlaylistDetailViewController(
            reactor: MyPlaylistDetailReactor(
                key: key,
                fetchPlaylistDetailUseCase: dependency.fetchPlaylistDetailUseCase,
                updatePlaylistUseCase: dependency.updatePlaylistUseCase,
                updateTitleAndPrivateUseCase: dependency.updateTitleAndPrivateUseCase,
                removeSongsUseCase: dependency.removeSongsUseCase,
                uploadDefaultPlaylistImageUseCase: dependency.uploadDefaultPlaylistImageUseCase,
                requestCustomImageURLUseCase: dependency.requestCustomImageURLUseCase,
                logoutUseCase: dependency.logoutUseCase
            ),
            multiPurposePopupFactory: dependency.multiPurposePopupFactory,
            containSongsFactory: dependency.containSongsFactory,
            textPopupFactory: dependency.textPopupFactory,
            playlistCoverOptionPopupFactory: dependency.playlistCoverOptionPopupFactory,
            checkPlaylistCoverFactory: dependency.checkPlaylistCoverFactory,
            defaultPlaylistCoverFactory: dependency.defaultPlaylistCoverFactory,
            songDetailPresenter: dependency.songDetailPresenter
        )
    }
}
