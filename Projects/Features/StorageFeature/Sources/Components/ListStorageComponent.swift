import AuthDomainInterface
import BaseFeature
import BaseFeatureInterface
import Foundation
import FruitDrawFeatureInterface
import NeedleFoundation
import PlaylistDomainInterface
import PlaylistFeatureInterface
import PriceDomainInterface
import SignInFeatureInterface
import UIKit
import UserDomainInterface

public protocol ListStorageDependency: Dependency {
    var multiPurposePopupFactory: any MultiPurposePopupFactory { get }
    var playlistDetailFactory: any PlaylistDetailFactory { get }
    var createPlaylistUseCase: any CreatePlaylistUseCase { get }
    var editPlayListOrderUseCase: any EditPlaylistOrderUseCase { get }
    var fetchPlayListUseCase: any FetchPlaylistUseCase { get }
    var deletePlayListUseCase: any DeletePlaylistUseCase { get }
    var fetchPlaylistSongsUseCase: any FetchPlaylistSongsUseCase { get }
    var fetchPlaylistCreationPriceUseCase: any FetchPlaylistCreationPriceUseCase { get }
    var logoutUseCase: any LogoutUseCase { get }
    var textPopupFactory: any TextPopupFactory { get }
    var signInFactory: any SignInFactory { get }
    var fruitDrawFactory: any FruitDrawFactory { get }
}

public final class ListStorageComponent: Component<ListStorageDependency> {
    public func makeView() -> UIViewController {
        return ListStorageViewController(
            reactor: ListStorageReactor(
                storageCommonService: DefaultStorageCommonService.shared,
                createPlaylistUseCase: dependency.createPlaylistUseCase,
                fetchPlayListUseCase: dependency.fetchPlayListUseCase,
                editPlayListOrderUseCase: dependency.editPlayListOrderUseCase,
                deletePlayListUseCase: dependency.deletePlayListUseCase,
                fetchPlaylistSongsUseCase: dependency.fetchPlaylistSongsUseCase,
                fetchPlaylistCreationPriceUseCase: dependency.fetchPlaylistCreationPriceUseCase
            ),
            multiPurposePopupFactory: dependency.multiPurposePopupFactory,
            textPopupFactory: dependency.textPopupFactory,
            playlistDetailFactory: dependency.playlistDetailFactory,
            signInFactory: dependency.signInFactory,
            fruitDrawFactory: dependency.fruitDrawFactory
        )
    }
}
