import BaseDomainInterface
import Foundation
import RxSwift

public protocol DeletePlaylistUseCase: Sendable {
    func execute(ids: [String]) -> Completable
}
