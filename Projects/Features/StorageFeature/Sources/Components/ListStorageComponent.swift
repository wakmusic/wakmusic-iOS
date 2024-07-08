import AuthDomainInterface
import BaseFeature
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import PlaylistFeatureInterface
import SignInFeatureInterface
import UIKit
import UserDomainInterface

public protocol ListStorageDependency: Dependency {
    var multiPurposePopUpFactory: any MultiPurposePopupFactory { get }
    var playlistDetailFactory: any PlaylistDetailFactory { get }
    var fetchPlayListUseCase: any FetchPlayListUseCase { get }
    var editPlayListOrderUseCase: any EditPlayListOrderUseCase { get }
    var deletePlayListUseCase: any DeletePlayListUseCase { get }
    var logoutUseCase: any LogoutUseCase { get }
    var textPopUpFactory: any TextPopUpFactory { get }
    var signInFactory: any SignInFactory { get }
}

public final class ListStorageComponent: Component<ListStorageDependency> {
    public func makeView() -> UIViewController {
        return ListStorageViewController.viewController(
            reactor: ListStorageReactor(),
            multiPurposePopUpFactory: dependency.multiPurposePopUpFactory,
            playlistDetailFactory: dependency.playlistDetailFactory,
            textPopUpFactory: dependency.textPopUpFactory,
            signInFactory: dependency.signInFactory
        )
    }
}
