import Foundation
import NoticeDomainInterface
import RxRelay
import RxSwift
import Utility

public final class MainTabBarViewModel {
    private let fetchNoticeAllUseCase: FetchNoticeAllUseCase
    private let disposeBag = DisposeBag()

    public init(
        fetchNoticeAllUseCase: any FetchNoticeAllUseCase
    ) {
        self.fetchNoticeAllUseCase = fetchNoticeAllUseCase
    }

    public struct Input {
        let fetchNoticePopup: PublishSubject<Void> = PublishSubject()
    }

    public struct Output {
        let dataSource: BehaviorRelay<[FetchNoticeEntity]> = BehaviorRelay(value: [])
    }

    public func transform(from input: Input) -> Output {
        let output = Output()
        let igoredNoticeIds: [Int] = Utility.PreferenceManager.ignoredNoticeIDs ?? []
        DEBUG_LOG("igoredNoticeIds: \(igoredNoticeIds)")

        input.fetchNoticePopup
            .flatMap { [fetchNoticeAllUseCase] _ -> Single<[FetchNoticeEntity]> in
                return fetchNoticeAllUseCase.execute()
                    .catchAndReturn([])
            }
            .map { entities in
                guard !igoredNoticeIds.isEmpty else { return entities }
                return entities.filter { entity in
                    return !igoredNoticeIds.contains(where: { $0 == entity.id })
                }
            }
            .debug("igoredNoticeIds")
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)

        return output
    }
}
