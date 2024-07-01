import BaseFeature
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import SignInFeatureInterface
import StorageFeatureInterface
import UIKit
import UserDomainInterface

public protocol StorageDependency: Dependency {
    var signInFactory: any SignInFactory { get }
    var textPopUpFactory: any TextPopUpFactory { get }
    var multiPurposePopUpFactory: any MultiPurposePopupFactory { get }
    var playlistStorageComponent: PlaylistStorageComponent { get }
    var favoriteComponent: FavoriteComponent { get }
    var fetchPlayListUseCase: any FetchPlayListUseCase { get }
    var editPlayListOrderUseCase: any EditPlayListOrderUseCase { get }
    var deletePlayListUseCase: any DeletePlayListUseCase { get }
}

public final class StorageComponent: Component<StorageDependency>, StorageFactory {
    public func makeView() -> UIViewController {
//        return StorageViewController.viewController(
//            reactor: StorageReactor(),
//            playlistStorageComponent: dependency.playlistStorageComponent,
//            multiPurposePopUpFactory: dependency.multiPurposePopUpFactory,
//            favoriteComponent: dependency.favoriteComponent,
//            textPopUpFactory: dependency.textPopUpFactory,
//            signInFactory: dependency.signInFactory
//        )
        return NewStorageViewController.viewController(
            reactor: StorageReactor(
                fetchPlayListUseCase: dependency.fetchPlayListUseCase,
                editPlayListOrderUseCase: dependency.editPlayListOrderUseCase,
                deletePlayListUseCase: dependency.deletePlayListUseCase
            ),
            playlistStorageComponent: dependency.playlistStorageComponent,
            multiPurposePopUpFactory: dependency.multiPurposePopUpFactory,
            favoriteComponent: dependency.favoriteComponent,
            textPopUpFactory: dependency.textPopUpFactory,
            signInFactory: dependency.signInFactory
        )
    }
}
