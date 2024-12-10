import Foundation
import RxSwift

public protocol FetchCurrentVideoUseCase: Sendable {
    func execute() -> Single<CurrentVideoEntity>
}
