import BaseFeature
import Foundation
import MyInfoFeatureInterface
import NoticeDomainInterface
import RxRelay
import RxSwift
import Utility

public final class NoticeViewModel {
    private let fetchNoticeAllUseCase: FetchNoticeAllUseCase
    private let disposeBag = DisposeBag()

    public init(
        fetchNoticeAllUseCase: any FetchNoticeAllUseCase
    ) {
        self.fetchNoticeAllUseCase = fetchNoticeAllUseCase
    }

    public struct Input {
        let fetchNotice: PublishSubject<Void> = PublishSubject()
        let didTapList: PublishSubject<IndexPath> = PublishSubject()
    }

    public struct Output {
        let dataSource: BehaviorRelay<[FetchNoticeEntity]> = BehaviorRelay(value: [])
        let goNoticeDetailScene: PublishSubject<FetchNoticeEntity> = PublishSubject()
    }

    public func transform(from input: Input) -> Output {
        let output = Output()

        input.fetchNotice
            .flatMap { [fetchNoticeAllUseCase] _ -> Single<[FetchNoticeEntity]> in
                return fetchNoticeAllUseCase.execute()
                    .catchAndReturn([])
            }
            .map { notices in
                let readIDs = Set(PreferenceManager.readNoticeIDs ?? [])
                return notices.map { notice in
                    var notice = notice
                    notice.isRead = readIDs.contains(notice.id)
                    return notice
                }
            }
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)

        input.didTapList
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .map { selectedIndexPath, notices in
                let selecterdID = notices[selectedIndexPath.row].id
                return notices.map { notice in
                    var updatedNotice = notice
                    updatedNotice.isRead = (notice.id == selecterdID) ? true : notice.isRead
                    return updatedNotice
                }
            }
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)

        input.didTapList
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .map { selectedIndexPath, entities in
                entities[selectedIndexPath.row]
            }
            .bind(to: output.goNoticeDetailScene)
            .disposed(by: disposeBag)

        return output
    }
}
