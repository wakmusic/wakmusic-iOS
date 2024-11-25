import Foundation
import RxSwift

public protocol FetchNoticeIDListUseCase: Sendable {
    func execute() -> Single<FetchNoticeIDListEntity>
}
