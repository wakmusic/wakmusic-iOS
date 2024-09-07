import Foundation
import RxSwift

public protocol FetchNoticeAllUseCase {
    func execute() -> Single<[FetchNoticeEntity]>
}
