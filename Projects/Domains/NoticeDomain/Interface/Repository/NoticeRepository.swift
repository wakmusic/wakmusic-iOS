import Foundation
import RxSwift

public protocol NoticeRepository {
    func fetchNoticeCategories() -> Single<FetchNoticeCategoriesEntity>
    func fetchNoticePopup() -> Single<[FetchNoticeEntity]>
    func fetchNoticeAll() -> Single<[FetchNoticeEntity]>
    func fetchNoticeIDList() -> Single<FetchNoticeIDListEntity>
}
