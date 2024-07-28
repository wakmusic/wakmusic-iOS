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
            .flatMap { [fetchArtistSubscriptionStatusUseCase] _ -> Observable<ArtistSubscriptionStatusEntity> in
                if PreferenceManager.userInfo == nil {
                    return Observable.just(ArtistSubscriptionStatusEntity(isSubscription: false))
                } else {
                    return fetchArtistSubscriptionStatusUseCase.execute(id: id)
                        .asObservable()
                        .catchAndReturn(.init(isSubscription: false))
                }
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
            .flatMap { [subscriptionArtistUseCase] status -> Observable<Bool> in
                return subscriptionArtistUseCase.execute(id: id, on: !status)
                    .andThen(Observable.just(!status))
                    .catch { error in
                        output.showToast.onNext(error.asWMError.errorDescription ?? error.localizedDescription)
                        return Observable.empty()
                    }
            }
            .subscribe(onNext: { isSubscribe in
                output.isSubscription.accept(isSubscribe)
                output.showToast.onNext(
                    isSubscribe ?
                        "신곡 알림이 등록되었습니다." : "신곡 알림이 해제되었습니다."
                )
            })
            .disposed(by: disposeBag)

        return output
    }
}
