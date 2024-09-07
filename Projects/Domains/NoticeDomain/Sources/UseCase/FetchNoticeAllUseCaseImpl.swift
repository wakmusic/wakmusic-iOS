import Foundation
import NoticeDomainInterface
import RxSwift

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
