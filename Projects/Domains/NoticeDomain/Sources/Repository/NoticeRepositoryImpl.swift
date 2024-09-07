import Foundation
import NoticeDomainInterface
import RxSwift

public final class NoticeRepositoryImpl: NoticeRepository {
    private let remoteNoticeDataSource: any RemoteNoticeDataSource

    public init(
        remoteNoticeDataSource: RemoteNoticeDataSource
    ) {
        self.remoteNoticeDataSource = remoteNoticeDataSource
    }

    public func fetchNoticeCategories() -> Single<FetchNoticeCategoriesEntity> {
        remoteNoticeDataSource.fetchNoticeCategories()
    }

    public func fetchNoticePopup() -> Single<[FetchNoticeEntity]> {
        remoteNoticeDataSource.fetchNoticePopup()
    }

    public func fetchNoticeAll() -> Single<[FetchNoticeEntity]> {
        remoteNoticeDataSource.fetchNoticeAll()
    }

    public func fetchNoticeIDList() -> Single<FetchNoticeIDListEntity> {
        remoteNoticeDataSource.fetchNoticeIDList()
    }
}
