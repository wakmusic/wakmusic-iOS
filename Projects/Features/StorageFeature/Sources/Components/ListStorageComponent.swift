import AuthDomainInterface
import BaseFeature
import BaseFeatureInterface
import Foundation
import FruitDrawFeatureInterface
import NeedleFoundation
import PlaylistDomainInterface
import PlaylistFeatureInterface
import SignInFeatureInterface
import UIKit
import UserDomainInterface

public protocol ListStorageDependency: Dependency {
    var multiPurposePopUpFactory: any MultiPurposePopupFactory { get }
    var playlistDetailFactory: any PlaylistDetailFactory { get }
    var createPlaylistUseCase: any CreatePlaylistUseCase { get }
    var editPlayListOrderUseCase: any EditPlayListOrderUseCase { get }
    var fetchPlayListUseCase: any FetchPlayListUseCase { get }
    var deletePlayListUseCase: any DeletePlayListUseCase { get }
    var logoutUseCase: any LogoutUseCase { get }
    var textPopUpFactory: any TextPopUpFactory { get }
    var signInFactory: any SignInFactory { get }
    var fruitDrawFactory: any FruitDrawFactory { get }
}

public final class ListStorageComponent: Component<ListStorageDependency> {
    public func makeView() -> UIViewController {
        return ListStorageViewController(
            reactor: ListStorageReactor(
                createPlaylistUseCase: dependency.createPlaylistUseCase,
                fetchPlayListUseCase: dependency.fetchPlayListUseCase,
                editPlayListOrderUseCase: dependency.editPlayListOrderUseCase,
                deletePlayListUseCase: dependency.deletePlayListUseCase
            ),
            multiPurposePopUpFactory: dependency.multiPurposePopUpFactory,
            textPopUpFactory: dependency.textPopUpFactory, 
            playlistDetailFactory: dependency.playlistDetailFactory,
            signInFactory: dependency.signInFactory,
            fruitDrawFactory: dependency.fruitDrawFactory
        )
    }
}
