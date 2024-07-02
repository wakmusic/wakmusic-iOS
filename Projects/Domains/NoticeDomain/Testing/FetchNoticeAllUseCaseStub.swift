import Foundation
import NoticeDomainInterface
import RxSwift

public struct FetchNoticeAllUseCaseStub: FetchNoticeAllUseCase {
    public func execute() -> Single<[FetchNoticeEntity]> {
        return .just([])
    }
}
