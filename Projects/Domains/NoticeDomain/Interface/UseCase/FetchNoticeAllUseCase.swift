import Foundation
import RxSwift

public protocol FetchNoticeAllUseCase: Sendable {
    func execute() -> Single<[FetchNoticeEntity]>
}
