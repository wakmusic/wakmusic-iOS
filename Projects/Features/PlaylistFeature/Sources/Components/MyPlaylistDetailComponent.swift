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

    var multiPurposePopUpFactory: any MultiPurposePopupFactory { get }
    var containSongsFactory: any ContainSongsFactory { get }
    var thumbnailPopupFactory: any ThumbnailPopupFactory { get }
    var checkThumbnailFactory: any CheckThumbnailFactory { get }
    var defaultPlaylistImageFactory: any DefaultPlaylistImageFactory { get }
    var fetchCustomImageUrlUseCase: any FetchCustomImageUrlUseCase { get }

    var textPopUpFactory: any TextPopUpFactory { get }
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
                fetchCustomImageUrlUseCase: dependency.fetchCustomImageUrlUseCase,
                logoutUseCase: dependency.logoutUseCase
            ),
            multiPurposePopupFactory: dependency.multiPurposePopUpFactory,
            containSongsFactory: dependency.containSongsFactory,
            textPopUpFactory: dependency.textPopUpFactory,
            thumbnailPopupFactory: dependency.thumbnailPopupFactory,
            checkThumbnailFactory: dependency.checkThumbnailFactory,
            defaultPlaylistImageFactory: dependency.defaultPlaylistImageFactory
        )
    }
}
