import ArtistFeatureInterface
import CreditSongListFeatureInterface
import NeedleFoundation
import SongCreditFeatureInterface
import SongsDomainInterface
import UIKit

public protocol SongCreditDependency: Dependency {
    var fetchSongCreditsUseCase: any FetchSongCreditsUseCase { get }
    var creditSongListFactory: any CreditSongListFactory { get }
    var artistDetailFactory: any ArtistDetailFactory { get }
}

public final class SongCreditComponent: Component<SongCreditDependency>, SongCreditFactory {
    public func makeViewController(songID: String) -> UIViewController {
        let reactor = SongCreditReactor(
            songID: songID,
            fetchSongCreditsUseCase: dependency.fetchSongCreditsUseCase
        )
        let viewController = SongCreditViewController(
            reactor: reactor,
            creditSongListFactory: dependency.creditSongListFactory,
            artistDetailFactory: dependency.artistDetailFactory
        )
        return viewController
    }
}
