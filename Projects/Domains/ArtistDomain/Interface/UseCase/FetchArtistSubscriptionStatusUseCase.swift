import Foundation
import RxSwift

public protocol FetchArtistSubscriptionStatusUseCase {
    func execute(id: String) -> Single<ArtistSubscriptionStatusEntity>
}
