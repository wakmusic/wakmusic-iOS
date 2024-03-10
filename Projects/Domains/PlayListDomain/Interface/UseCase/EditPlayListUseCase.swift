import Foundation
import RxSwift
import BaseDomainInterface

public protocol EditPlayListUseCase {
    func execute(key: String, songs: [String]) -> Single<BaseEntity>
}
