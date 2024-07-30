import NeedleFoundation
import SongCreditFeatureInterface
import SongsDomainInterface
import UIKit

public protocol SongCreditDependency: Dependency {
    var fetchSongCreditsUseCase: any FetchSongCreditsUseCase { get }
}

public final class SongCreditComponent: Component<SongCreditDependency>, SongCreditFactory {
    public func makeViewController(songID: String) -> UIViewController {
        let reactor = SongCreditReactor(
            songID: songID,
            fetchSongCreditsUseCase: dependency.fetchSongCreditsUseCase
        )
        let viewController = SongCreditViewController(
            reactor: reactor
        )
        return viewController
    }
}
