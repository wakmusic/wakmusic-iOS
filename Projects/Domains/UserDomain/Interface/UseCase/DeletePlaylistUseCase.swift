import BaseDomainInterface
import Foundation
import RxSwift

public protocol DeletePlaylistUseCase {
    func execute(ids: [String]) -> Single<BaseEntity>
}
