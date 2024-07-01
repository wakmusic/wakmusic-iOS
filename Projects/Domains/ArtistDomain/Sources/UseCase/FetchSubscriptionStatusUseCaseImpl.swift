import ArtistDomainInterface
import Foundation
import RxSwift

public struct FetchSubscriptionStatusUseCaseImpl: FetchArtistSubscriptionStatusUseCase {
    private let artistRepository: any ArtistRepository

    public init(
        artistRepository: ArtistRepository
    ) {
        self.artistRepository = artistRepository
    }

    public func execute(id: String) -> Single<ArtistSubscriptionStatusEntity> {
        artistRepository.fetchArtistSubscriptionStatus(id: id)
    }
}
