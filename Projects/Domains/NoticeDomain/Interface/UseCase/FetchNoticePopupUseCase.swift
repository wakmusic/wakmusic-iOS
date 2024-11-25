import Foundation
import RxSwift

public protocol FetchNoticePopupUseCase: Sendable {
    func execute() -> Single<[FetchNoticeEntity]>
}
