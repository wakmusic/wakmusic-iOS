import ArtistDomainInterface
import BaseFeature
import Foundation
import RxRelay
import RxSwift

public final class ArtistDetailViewModel: ViewModelType {
    private let model: ArtistListEntity
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
    }

    public struct Output {
        let isSubscription: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    }

    public func transform(from input: Input) -> Output {
        let output = Output()
        return output
    }
}
