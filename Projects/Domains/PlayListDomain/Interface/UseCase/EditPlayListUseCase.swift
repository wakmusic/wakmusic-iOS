import BaseDomainInterface
import Foundation
import RxSwift

public protocol EditPlayListUseCase {
    func execute(key: String, songs: [String]) -> Single<BaseEntity>
}
