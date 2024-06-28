import BaseFeature
import Foundation
import LogManager
import RxRelay
import RxSwift
import UserDomainInterface
import Utility
import Kingfisher

public final class FruitDrawViewModel: ViewModelType {
    private let fetchFruitDrawStatusUseCase: FetchFruitDrawStatusUseCase
    private let drawFruitUseCase: DrawFruitUseCase
    private let disposeBag = DisposeBag()

    deinit {
        LogManager.printDebug("❌:: \(Self.self) deinit")
    }

    public init(
        fetchFruitDrawStatusUseCase: any FetchFruitDrawStatusUseCase,
        drawFruitUseCase: any DrawFruitUseCase
    ) {
        self.fetchFruitDrawStatusUseCase = fetchFruitDrawStatusUseCase
        self.drawFruitUseCase = drawFruitUseCase
    }

    public struct Input {
        let fetchFruitDrawStatus: PublishSubject<Void> = PublishSubject()
        let didTapFruitDraw: PublishSubject<Void> = PublishSubject()
        let endedLottieAnimation: PublishSubject<Void> = PublishSubject()
    }

    public struct Output {
        let canDraw: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        let fruitSource: BehaviorRelay<FruitEntity> = BehaviorRelay(value: .init(
            quantity: 0,
            fruitID: "",
            name: "",
            imageURL: ""
        ))
        let showRewardNote: PublishSubject<FruitEntity> = PublishSubject()
        let showToast: PublishSubject<String> = PublishSubject()
    }

    public func transform(from input: Input) -> Output {
        let output = Output()

        input.fetchFruitDrawStatus
            .flatMap { [fetchFruitDrawStatusUseCase] _ in
                return fetchFruitDrawStatusUseCase.execute()
                    .catchAndReturn(
                        .init(
                            canDraw: false,
                            lastDraw: .init(
                                drawAt: 0,
                                fruit: .init(fruitID: "", name: "", imageURL: "")
                            )
                        )
                    )
            }
            .map { $0.canDraw }
            .bind(to: output.canDraw)
            .disposed(by: disposeBag)

        input.didTapFruitDraw
            .flatMap { [drawFruitUseCase] _ in
                return drawFruitUseCase.execute()
                    .catchAndReturn(.init(quantity: 0, fruitID: "", name: "", imageURL: ""))
            }
            .filter { $0.quantity > 0 }
            .flatMap { [weak self] entity -> Observable<(FruitEntity, Data?)> in
                guard let self = self else { return .never() }
                return self.downloadNoteImage(entity: entity)
            }
            .map { (entity, data) -> FruitEntity in
                var newEntity = entity
                newEntity.imageData = data
                return newEntity
            }
            .bind(to: output.fruitSource)
            .disposed(by: disposeBag)

        let combineObservable = Observable.combineLatest(
            input.endedLottieAnimation,
            output.fruitSource.skip(1)
        ) { (_, fruit) -> FruitEntity in
            return fruit
        }

        combineObservable
            .debug()
            .bind(to: output.showRewardNote)
            .disposed(by: disposeBag)

        return output
    }
}

private extension FruitDrawViewModel {
    func downloadNoteImage(entity: FruitEntity) -> Observable<(FruitEntity, Data?)> {
        guard let URL = URL(string: entity.imageURL) else { return .never() }
        return Observable.create { observer in
            KingfisherManager.shared.retrieveImage(
                with: URL
            ) { result in
                switch result {
                case let .success(value):
                    observer.onNext((entity, value.data()))
                    observer.onCompleted()

                case let .failure(error):
                    LogManager.printDebug(error.localizedDescription)
                    observer.onNext((entity, Data()))
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}
