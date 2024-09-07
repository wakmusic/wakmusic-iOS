import ArtistDomainInterface
import Foundation
import RxSwift

public struct FetchArtistListUseCaseImpl: FetchArtistListUseCase {
    private let artistRepository: any ArtistRepository

    public init(
        artistRepository: ArtistRepository
    ) {
        self.artistRepository = artistRepository
    }

    public func execute() -> Single<[ArtistEntity]> {
        artistRepository.fetchArtistList()
    }
}
