import Foundation
import RxSwift

public protocol LoadPlayListUseCase {
    func execute(key: String) -> Single<PlayListBaseEntity>
}
