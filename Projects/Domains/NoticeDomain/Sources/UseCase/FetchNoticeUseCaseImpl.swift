import Foundation
import NoticeDomainInterface
import RxSwift

public struct FetchNoticeUseCaseImpl: FetchNoticeUseCase {
    private let noticeRepository: any NoticeRepository

    public init(
        noticeRepository: NoticeRepository
    ) {
        self.noticeRepository = noticeRepository
    }

    public func execute(type: NoticeType) -> Single<[FetchNoticeEntity]> {
        noticeRepository.fetchNotice(type: type)
    }
}
