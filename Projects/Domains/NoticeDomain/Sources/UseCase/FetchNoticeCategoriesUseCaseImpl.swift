import Foundation
import NoticeDomainInterface
import RxSwift

public struct FetchNoticeCategoriesUseCaseImpl: FetchNoticeCategoriesUseCase {
    private let noticeRepository: any NoticeRepository

    public init(
        noticeRepository: NoticeRepository
    ) {
        self.noticeRepository = noticeRepository
    }

    public func execute() -> Single<FetchNoticeCategoriesEntity> {
        noticeRepository.fetchNoticeCategories()
    }
}
