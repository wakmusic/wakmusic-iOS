import Foundation
import RxSwift

public protocol FetchArtistDetailUseCase: Sendable {
    func execute(id: String) -> Single<ArtistEntity>
}
