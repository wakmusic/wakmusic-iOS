import AuthDomainInterface
import BaseFeature
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import PlaylistFeatureInterface
import SignInFeatureInterface
import UIKit
import UserDomainInterface

public protocol PlaylistStorageDependency: Dependency {
    var multiPurposePopUpFactory: any MultiPurposePopUpFactory { get }
    var playlistDetailFactory: any PlaylistDetailFactory { get }
    var fetchPlayListUseCase: any FetchPlayListUseCase { get }
    var editPlayListOrderUseCase: any EditPlayListOrderUseCase { get }
    var deletePlayListUseCase: any DeletePlayListUseCase { get }
    var logoutUseCase: any LogoutUseCase { get }
    var textPopUpFactory: any TextPopUpFactory { get }
    var signInFactory: any SignInFactory { get }
}

public final class PlaylistStorageComponent: Component<PlaylistStorageDependency> {
    public func makeView() -> UIViewController {
        return PlaylistStorageViewController.viewController(
            reactor: PlaylistStorageReactor(),
            multiPurposePopUpFactory: dependency.multiPurposePopUpFactory,
            playlistDetailFactory: dependency.playlistDetailFactory,
            textPopUpFactory: dependency.textPopUpFactory,
            signInFactory: dependency.signInFactory
        )
    }
}
