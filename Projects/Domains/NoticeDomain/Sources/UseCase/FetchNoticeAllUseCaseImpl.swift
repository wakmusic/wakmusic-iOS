import Foundation
import RxSwift
import NoticeDomainInterface

public struct FetchNoticeAllUseCaseImpl: FetchNoticeAllUseCase {
    private let noticeRepository: any NoticeRepository

    public init(
        noticeRepository: NoticeRepository
    ) {
        self.noticeRepository = noticeRepository
    }
    
    public func execute() -> Single<[FetchNoticeEntity]> {
        return noticeRepository.fetchNoticeAll()
    }
}
