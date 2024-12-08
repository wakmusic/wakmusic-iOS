import Foundation
import RxSwift

public protocol SubscriptionArtistUseCase: Sendable {
    func execute(id: String, on: Bool) -> Completable
}
