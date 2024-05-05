import AuthDomainInterface
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import PlayListDomainInterface
import UIKit
import UserDomainInterface

public protocol ContainSongsDependency: Dependency {
    var multiPurposePopUpFactory: any MultiPurposePopUpFactory { get }
    var fetchPlayListUseCase: any FetchPlayListUseCase { get }
    var addSongIntoPlayListUseCase: any AddSongIntoPlayListUseCase { get }
    var logoutUseCase: any LogoutUseCase { get }
}

public final class ContainSongsComponent: Component<ContainSongsDependency>, ContainSongsFactory {
    public func makeView(songs: [String]) -> UIViewController {
        return ContainSongsViewController.viewController(
            multiPurposePopUpFactory: dependency.multiPurposePopUpFactory,
            viewModel: .init(
                songs: songs,
                fetchPlayListUseCase: dependency.fetchPlayListUseCase,
                addSongIntoPlayListUseCase: dependency.addSongIntoPlayListUseCase,
                logoutUseCase: dependency.logoutUseCase
            )
        )
    }
}
