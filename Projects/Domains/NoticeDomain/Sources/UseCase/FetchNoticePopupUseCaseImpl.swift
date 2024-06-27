import Foundation
import RxSwift
import NoticeDomainInterface

public struct FetchNoticePopupUseCaseImpl: FetchNoticePopupUseCase {
    private let noticeRepository: any NoticeRepository

    public init(
        noticeRepository: NoticeRepository
    ) {
        self.noticeRepository = noticeRepository
    }
    
    public func execute() -> Single<[FetchNoticeEntity]> {
        return noticeRepository.fetchNoticePopup()
    }
}
