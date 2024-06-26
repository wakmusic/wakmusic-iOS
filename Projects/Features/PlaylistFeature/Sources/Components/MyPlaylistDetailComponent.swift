import AuthDomainInterface
import BaseFeature
import BaseFeatureInterface
import NeedleFoundation
import PlaylistDomainInterface
import PlaylistFeatureInterface
import UIKit

public protocol MyPlaylistDetailDependency: Dependency {
    #warning("추후 주입")
    var fetchPlaylistDetailUseCase: any FetchPlaylistDetailUseCase { get }
    var updatePlaylistUseCase: any UpdatePlaylistUseCase { get }
    var updateTitleAndPrivateUseCase: any UpdateTitleAndPrivateUseCase { get }
    var addSongIntoPlaylistUseCase: any AddSongIntoPlaylistUseCase { get }
    var removeSongsUseCase: any RemoveSongsUseCase { get }
    var uploadPlaylistImageUseCase: any UploadPlaylistImageUseCase { get }

    var logoutUseCase: any LogoutUseCase { get }

    var multiPurposePopUpFactory: any MultiPurposePopUpFactory { get }
    var containSongsFactory: any ContainSongsFactory { get }

    var textPopUpFactory: any TextPopUpFactory { get }
}

public final class MyPlaylistDetailComponent: Component<MyPlaylistDetailDependency>, MyPlaylistFactory {
    public func makeView(key: String) -> UIViewController {
        return MyPlaylistDetailViewController(reactor: MyPlaylistDetailReactor(key: key))
    }
}
