import Foundation
import NoticeDomainInterface
import RxSwift

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
