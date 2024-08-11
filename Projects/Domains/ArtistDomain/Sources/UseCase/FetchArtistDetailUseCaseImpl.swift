import ArtistDomainInterface
import Foundation
import RxSwift

public struct FetchArtistDetailUseCaseImpl: FetchArtistDetailUseCase {
    private let artistRepository: any ArtistRepository

    public init(
        artistRepository: ArtistRepository
    ) {
        self.artistRepository = artistRepository
    }

    public func execute(id: String) -> Single<ArtistEntity> {
        artistRepository.fetchArtistDetail(id: id)
    }
}
