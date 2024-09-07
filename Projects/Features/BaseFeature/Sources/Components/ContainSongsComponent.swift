import AuthDomainInterface
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import PlaylistDomainInterface
import PriceDomainInterface
import UIKit
import UserDomainInterface

public protocol ContainSongsDependency: Dependency {
    var multiPurposePopupFactory: any MultiPurposePopupFactory { get }
    var fetchPlayListUseCase: any FetchPlaylistUseCase { get }
    var addSongIntoPlaylistUseCase: any AddSongIntoPlaylistUseCase { get }
    var createPlaylistUseCase: any CreatePlaylistUseCase { get }
    var fetchPlaylistCreationPriceUseCase: any FetchPlaylistCreationPriceUseCase { get }
    var textPopupFactory: any TextPopupFactory { get }
    var logoutUseCase: any LogoutUseCase { get }
}

public final class ContainSongsComponent: Component<ContainSongsDependency>, ContainSongsFactory {
    public func makeView(songs: [String]) -> UIViewController {
        return ContainSongsViewController.viewController(
            multiPurposePopupFactory: dependency.multiPurposePopupFactory,
            textPopupFactory: dependency.textPopupFactory,
            viewModel: .init(
                songs: songs,
                createPlaylistUseCase: dependency.createPlaylistUseCase,
                fetchPlayListUseCase: dependency.fetchPlayListUseCase,
                addSongIntoPlaylistUseCase: dependency.addSongIntoPlaylistUseCase,
                fetchPlaylistCreationPriceUsecase: dependency.fetchPlaylistCreationPriceUseCase,
                logoutUseCase: dependency.logoutUseCase
            )
        )
    }
}
