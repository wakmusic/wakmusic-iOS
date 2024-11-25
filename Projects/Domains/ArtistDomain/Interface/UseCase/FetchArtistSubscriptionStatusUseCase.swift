import Foundation
import RxSwift

public protocol FetchArtistSubscriptionStatusUseCase: Sendable {
    func execute(id: String) -> Single<ArtistSubscriptionStatusEntity>
}
