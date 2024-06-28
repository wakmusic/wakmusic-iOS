import BaseFeature
import Foundation
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
        let showToast: PublishSubject<String> = PublishSubject()
        let showRewardNote: PublishRelay<String> = PublishRelay()
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
            .bind(to: output.fruitSource)
            .disposed(by: disposeBag)
//
//        Observable.zip(input.endedLottieAnimation, output.dataSource)
//            .subscribe()
//            .disposed(by: disposeBag)

        return output
    }
}
