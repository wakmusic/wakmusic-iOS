import AuthDomainInterface
import BaseFeature
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import PlaylistFeatureInterface
import SignInFeatureInterface
import UIKit
import UserDomainInterface
import FruitDrawFeatureInterface
import PlaylistDomainInterface

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
        return ListStorageViewController.viewController(
            reactor: ListStorageReactor(
                createPlaylistUseCase: dependency.createPlaylistUseCase,
                fetchPlayListUseCase: FetchPlayListUseCaseStub(),
                editPlayListOrderUseCase: dependency.editPlayListOrderUseCase,
                deletePlayListUseCase: dependency.deletePlayListUseCase
            ),
            multiPurposePopUpFactory: dependency.multiPurposePopUpFactory,
            playlistDetailFactory: dependency.playlistDetailFactory,
            textPopUpFactory: dependency.textPopUpFactory,
            signInFactory: dependency.signInFactory,
            fruitDrawFactory: dependency.fruitDrawFactory
        )
    }
}
