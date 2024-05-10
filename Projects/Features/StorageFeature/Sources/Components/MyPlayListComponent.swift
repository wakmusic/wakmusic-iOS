import AuthDomainInterface
import BaseFeature
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import PlaylistFeatureInterface
import UserDomainInterface
import SignInFeatureInterface
import UIKit

public protocol MyPlayListDependency: Dependency {
    var multiPurposePopUpFactory: any MultiPurposePopUpFactory { get }
    var playlistDetailFactory: any PlaylistDetailFactory { get }
    var fetchPlayListUseCase: any FetchPlayListUseCase { get }
    var editPlayListOrderUseCase: any EditPlayListOrderUseCase { get }
    var deletePlayListUseCase: any DeletePlayListUseCase { get }
    var logoutUseCase: any LogoutUseCase { get }
    var textPopUpFactory: any TextPopUpFactory { get }
    var signInFactory: any SignInFactory { get }
}

public final class MyPlayListComponent: Component<MyPlayListDependency> {
    public func makeView() -> UIViewController {
        return MyPlayListViewController.viewController(
//            viewModel: .init(
//                fetchPlayListUseCase: dependency.fetchPlayListUseCase,
//                editPlayListOrderUseCase: dependency.editPlayListOrderUseCase,
//                deletePlayListUseCase: dependency.deletePlayListUseCase,
//                logoutUseCase: dependency.logoutUseCase
//            ),
            reactor: MyPlaylistReactor(),
            multiPurposePopUpFactory: dependency.multiPurposePopUpFactory,
            playlistDetailFactory: dependency.playlistDetailFactory,
            textPopUpFactory: dependency.textPopUpFactory,
            signInFactory: dependency.signInFactory
        )
    }
}
