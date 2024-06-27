import Foundation
import RxSwift
import NoticeDomainInterface

public struct FetchNoticeIDListUseCaseImpl: FetchNoticeIDListUseCase {
    private let noticeRepository: any NoticeRepository

    public init(
        noticeRepository: NoticeRepository
    ) {
        self.noticeRepository = noticeRepository
    }
    
    public func execute() -> Single<FetchNoticeIDListEntity> {
        return noticeRepository.fetchNoticeIDList()
    }
}
