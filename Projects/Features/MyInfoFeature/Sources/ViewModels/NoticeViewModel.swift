import BaseFeature
import Foundation
import MyInfoFeatureInterface
import NoticeDomainInterface
import RxRelay
import RxSwift
import Utility

public final class NoticeViewModel {
    private let fetchNoticeUseCase: FetchNoticeUseCase
    private let disposeBag = DisposeBag()

    public init(
        fetchNoticeUseCase: any FetchNoticeUseCase
    ) {
        self.fetchNoticeUseCase = fetchNoticeUseCase
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
            .flatMap { [fetchNoticeUseCase] _ -> Single<[FetchNoticeEntity]> in
                return fetchNoticeUseCase.execute(type: .all)
                    .catchAndReturn([])
            }
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)

        input.didTapList
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .map { $0.1[$0.0.row] }
            .bind(to: output.goNoticeDetailScene)
            .disposed(by: disposeBag)

        return output
    }
}
