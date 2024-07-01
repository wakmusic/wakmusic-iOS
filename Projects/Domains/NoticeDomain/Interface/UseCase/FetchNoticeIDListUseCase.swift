import Foundation
import RxSwift

public protocol FetchNoticeIDListUseCase {
    func execute() -> Single<FetchNoticeIDListEntity>
}
