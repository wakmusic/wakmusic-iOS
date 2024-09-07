import Foundation
import RxSwift

public protocol FetchCurrentVideoUseCase {
    func execute() -> Single<CurrentVideoEntity>
}
