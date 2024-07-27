import AuthDomainInterface
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import PlaylistDomainInterface
import UIKit
import UserDomainInterface
import PriceDomainInterface

public protocol ContainSongsDependency: Dependency {
    var multiPurposePopUpFactory: any MultiPurposePopupFactory { get }
    var fetchPlayListUseCase: any FetchPlaylistUseCase { get }
    var addSongIntoPlaylistUseCase: any AddSongIntoPlaylistUseCase { get }
    var createPlaylistUseCase: any CreatePlaylistUseCase { get }
    var fetchPlaylistCreationPriceUsecase: any FetchPlaylistCreationPriceUsecase { get }
    var textPopUpFactory: any TextPopUpFactory { get }
    var logoutUseCase: any LogoutUseCase { get }
}

public final class ContainSongsComponent: Component<ContainSongsDependency>, ContainSongsFactory {
    public func makeView(songs: [String]) -> UIViewController {
        return ContainSongsViewController.viewController(
            multiPurposePopUpFactory: dependency.multiPurposePopUpFactory,
            textPopUpFactory: dependency.textPopUpFactory,
            viewModel: .init(
                songs: songs,
                createPlaylistUseCase: dependency.createPlaylistUseCase,
                fetchPlayListUseCase: dependency.fetchPlayListUseCase,
                addSongIntoPlaylistUseCase: dependency.addSongIntoPlaylistUseCase,
                fetchPlaylistCreationPriceUsecase: dependency.fetchPlaylistCreationPriceUsecase,
                logoutUseCase: dependency.logoutUseCase
            )
        )
    }
}
