import Foundation
import RxSwift

public protocol SubscriptionArtistUseCase {
    func execute(id: String, on: Bool) -> Completable
}
