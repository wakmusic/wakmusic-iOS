import Foundation
import RxSwift

public protocol FetchArtistListUseCase {
    func execute() -> Single<[ArtistEntity]>
}
