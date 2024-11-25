import Foundation
import RxSwift

public protocol FetchArtistListUseCase: Sendable {
    func execute() -> Single<[ArtistEntity]>
}
