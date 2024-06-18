import Foundation
import NoticeDomainInterface
import RxSwift

public struct FetchNoticeUseCaseStub: FetchNoticeUseCase {
    public func execute(type: NoticeType) -> Single<[FetchNoticeEntity]> {
        return .just([])
    }
}
