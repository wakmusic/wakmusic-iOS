import Foundation
import RxSwift

public protocol FetchArtistDetailUseCase {
    func execute(id: String) -> Single<ArtistEntity>
}
