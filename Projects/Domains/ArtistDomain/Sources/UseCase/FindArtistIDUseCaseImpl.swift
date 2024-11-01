import ArtistDomainInterface
import RxSwift

public struct FindArtistIDUseCaseImpl: FindArtistIDUseCase {
    private let artistRepository: any ArtistRepository

    public init(
        artistRepository: any ArtistRepository
    ) {
        self.artistRepository = artistRepository
    }

    public func execute(name: String) -> Single<String> {
        return artistRepository.findArtistID(name: name)
    }
}
