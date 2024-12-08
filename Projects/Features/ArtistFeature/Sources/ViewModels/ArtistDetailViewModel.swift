import ArtistDomainInterface
import BaseFeature
import Foundation
import Localization
import LogManager
import RxRelay
import RxSwift
import Utility

public final class ArtistDetailViewModel: ViewModelType {
    let artistID: String
    private let fetchArtistDetailUseCase: FetchArtistDetailUseCase
    private let fetchArtistSubscriptionStatusUseCase: FetchArtistSubscriptionStatusUseCase
    private let subscriptionArtistUseCase: SubscriptionArtistUseCase
    private let disposeBag = DisposeBag()

    public init(
        artistID: String,
        fetchArtistDetailUseCase: any FetchArtistDetailUseCase,
        fetchArtistSubscriptionStatusUseCase: any FetchArtistSubscriptionStatusUseCase,
        subscriptionArtistUseCase: any SubscriptionArtistUseCase
    ) {
        self.artistID = artistID
        self.fetchArtistDetailUseCase = fetchArtistDetailUseCase
        self.fetchArtistSubscriptionStatusUseCase = fetchArtistSubscriptionStatusUseCase
        self.subscriptionArtistUseCase = subscriptionArtistUseCase
    }

    public struct Input {
        let fetchArtistDetail: PublishSubject<Void> = PublishSubject()
        let fetchArtistSubscriptionStatus: PublishSubject<Void> = PublishSubject()
        let didTapSubscription: PublishSubject<Void> = PublishSubject()
    }

    public struct Output {
        let dataSource: BehaviorRelay<ArtistEntity?> = BehaviorRelay(value: nil)
        let isSubscription: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        let showToast: PublishSubject<String> = PublishSubject()
        let showLogin: PublishSubject<CommonAnalyticsLog.LoginButtonEntry> = PublishSubject()
        let showWarningNotification: PublishSubject<Void> = PublishSubject()
        let occurredError: PublishSubject<String> = PublishSubject()
    }

    public func transform(from input: Input) -> Output {
        let output = Output()
        let id = self.artistID

        input.fetchArtistDetail
            .flatMap { [fetchArtistDetailUseCase] _ in
                return fetchArtistDetailUseCase.execute(id: id)
                    .asObservable()
                    .catch { error in
                        output.occurredError
                            .onNext(error.asWMError.errorDescription ?? LocalizationStrings.unknownErrorWarning)
                        return Observable.empty()
                    }
            }
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)

        input.fetchArtistSubscriptionStatus
            .withLatestFrom(PreferenceManager.shared.$userInfo)
            .withLatestFrom(PreferenceManager.shared.$pushNotificationAuthorizationStatus) { ($0, $1 ?? false) }
            .flatMap { [fetchArtistSubscriptionStatusUseCase] userInfo, granted
                -> Observable<ArtistSubscriptionStatusEntity> in
                if userInfo == nil || granted == false {
                    return Observable.just(.init(isSubscription: false))
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
            .withLatestFrom(PreferenceManager.shared.$userInfo)
            .filter { userInfo in
                if userInfo == nil {
                    output.showLogin.onNext(.artistSubscribe)
                    return false
                }
                return true
            }
            .withLatestFrom(PreferenceManager.shared.$pushNotificationAuthorizationStatus)
            .map { $0 ?? false }
            .filter { granted in
                if granted == false {
                    output.showWarningNotification.onNext(())
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

        // 로그인/아웃, 기기알림 끔 상태 반영
        Observable.combineLatest(
            PreferenceManager.shared.$userInfo.map { $0?.ID }.distinctUntilChanged(),
            PreferenceManager.shared.$pushNotificationAuthorizationStatus.distinctUntilChanged().map { $0 ?? false }
        ) { id, granted -> (String?, Bool) in
            return (id, granted)
        }
        .skip(1)
        .map { _ in () }
        .bind(to: input.fetchArtistSubscriptionStatus)
        .disposed(by: disposeBag)

        return output
    }
}
