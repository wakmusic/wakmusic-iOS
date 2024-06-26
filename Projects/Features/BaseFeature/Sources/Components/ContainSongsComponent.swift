import AuthDomainInterface
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import PlaylistDomainInterface
import UIKit
import UserDomainInterface

public protocol ContainSongsDependency: Dependency {
    var multiPurposePopUpFactory: any MultiPurposePopUpFactory { get }
    var fetchPlayListUseCase: any FetchPlayListUseCase { get }
    var addSongIntoPlaylistUseCase: any AddSongIntoPlaylistUseCase { get }
    var logoutUseCase: any LogoutUseCase { get }
}

public final class ContainSongsComponent: Component<ContainSongsDependency>, ContainSongsFactory {
    public func makeView(songs: [String]) -> UIViewController {
        return ContainSongsViewController.viewController(
            multiPurposePopUpFactory: dependency.multiPurposePopUpFactory,
            viewModel: .init(
                songs: songs,
                fetchPlayListUseCase: dependency.fetchPlayListUseCase,
                addSongIntoPlaylistUseCase: dependency.addSongIntoPlaylistUseCase,
                logoutUseCase: dependency.logoutUseCase
            )
        )
    }
}
