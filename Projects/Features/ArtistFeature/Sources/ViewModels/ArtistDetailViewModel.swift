import ArtistDomainInterface
import BaseFeature
import Foundation
import LogManager
import RxRelay
import RxSwift
import Utility

public final class ArtistDetailViewModel: ViewModelType {
    let model: ArtistListEntity
    private let fetchArtistSubscriptionStatusUseCase: FetchArtistSubscriptionStatusUseCase
    private let subscriptionArtistUseCase: SubscriptionArtistUseCase
    private let disposeBag = DisposeBag()

    public init(
        model: ArtistListEntity,
        fetchArtistSubscriptionStatusUseCase: any FetchArtistSubscriptionStatusUseCase,
        subscriptionArtistUseCase: any SubscriptionArtistUseCase
    ) {
        self.model = model
        self.fetchArtistSubscriptionStatusUseCase = fetchArtistSubscriptionStatusUseCase
        self.subscriptionArtistUseCase = subscriptionArtistUseCase
    }

    public struct Input {
        let fetchArtistSubscriptionStatus: PublishSubject<Void> = PublishSubject()
        let didTapSubscription: PublishSubject<Void> = PublishSubject()
    }

    public struct Output {
        let isSubscription: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        let showToast: PublishSubject<String> = PublishSubject()
        let showLogin: PublishSubject<Void> = PublishSubject()
    }

    public func transform(from input: Input) -> Output {
        let output = Output()
        let id = model.id

        input.fetchArtistSubscriptionStatus
            .filter { PreferenceManager.userInfo != nil }
            .flatMap { [fetchArtistSubscriptionStatusUseCase] _ -> Observable<ArtistSubscriptionStatusEntity> in
                fetchArtistSubscriptionStatusUseCase.execute(id: id)
                    .asObservable()
                    .catchAndReturn(.init(isSubscription: false))
            }
            .map { $0.isSubscription }
            .bind(to: output.isSubscription)
            .disposed(by: disposeBag)

        input.didTapSubscription
            .do(onNext: { _ in
                LogManager.analytics(
                    ArtistAnalyticsLog.clickArtistSubscriptionButton(artist: id)
                )
            })
            .filter { _ in
                if PreferenceManager.userInfo == nil {
                    output.showLogin.onNext(())
                    return false
                }
                return true
            }
            .withLatestFrom(output.isSubscription)
            .flatMap { [subscriptionArtistUseCase] status -> Completable in
                subscriptionArtistUseCase.execute(id: id, on: !status)
                    .catch { error in
                        output.showToast.onNext(error.asWMError.errorDescription ?? error.localizedDescription)
                        return Completable.never()
                    }
            }
            .debug()
            .subscribe(onCompleted: {
                output.isSubscription.accept(!output.isSubscription.value)
            })
            .disposed(by: disposeBag)

        return output
    }
}
