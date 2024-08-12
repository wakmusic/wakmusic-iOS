import AuthDomainInterface
import BaseFeature
import Foundation
import Kingfisher
import LogManager
import RxRelay
import RxSwift
import UserDomainInterface
import Utility

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
        let occurredError: PublishSubject<String> = PublishSubject()
    }

    public func transform(from input: Input) -> Output {
        let output = Output()

        input.fetchFruitDrawStatus
            .flatMap { [fetchFruitDrawStatusUseCase] _ in
                return fetchFruitDrawStatusUseCase.execute()
                    .asObservable()
                    .catch { error in
                        let message = error.asWMError.errorDescription ?? error.localizedDescription
                        output.occurredError.onNext(message)
                        return .empty()
                    }
            }
            .do(onNext: { entity in
                let lastAt = (entity.lastDraw.drawAt / 1000.0)
                    .unixTimeToDate
                    .dateToString(format: "yyyy.MM.dd HH:mm:ss")
                LogManager.printDebug("Draw lastAt: \(lastAt)")
            })
            .map { $0.canDraw }
            .bind(to: output.canDraw)
            .disposed(by: disposeBag)

        input.didTapFruitDraw
            .flatMap { [drawFruitUseCase] _ in
                return drawFruitUseCase.execute()
                    .asObservable()
                    .catch { error in
                        let message = error.asWMError.errorDescription ?? error.localizedDescription
                        output.occurredError.onNext(message)
                        return .empty()
                    }
            }
            .flatMap { [weak self] entity -> Observable<(FruitEntity, Data?)> in
                guard let self = self else { return .never() }
                return self.downloadNoteImage(entity: entity)
            }
            .map { entity, data -> FruitEntity in
                var newEntity = entity
                newEntity.imageData = data
                return newEntity
            }
            .bind(to: output.fruitSource)
            .disposed(by: disposeBag)

        Observable.zip(
            input.endedLottieAnimation,
            output.fruitSource.skip(1)
        ) { _, entity -> FruitEntity in
            return entity
        }
        .debug("FruitDrawZip")
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
