import ArtistDomainInterface
import Foundation
import RxSwift

public struct SubscriptionArtistUseCaseImpl: SubscriptionArtistUseCase {
    private let artistRepository: any ArtistRepository

    public init(
        artistRepository: ArtistRepository
    ) {
        self.artistRepository = artistRepository
    }

    public func execute(id: String, on: Bool) -> Completable {
        artistRepository.subscriptionArtist(id: id, on: on)
    }
}
