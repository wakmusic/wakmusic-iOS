import Foundation
import RxSwift

public protocol FetchNoticePopupUseCase {
    func execute() -> Single<[FetchNoticeEntity]>
}
