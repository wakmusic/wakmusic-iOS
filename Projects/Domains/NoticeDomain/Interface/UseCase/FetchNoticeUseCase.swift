import Foundation
import RxSwift

public protocol FetchNoticeUseCase {
    func execute(type: NoticeType) -> Single<[FetchNoticeEntity]>
}
