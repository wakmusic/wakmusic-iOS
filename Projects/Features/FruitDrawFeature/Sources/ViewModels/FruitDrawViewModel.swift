import BaseFeature
import Foundation
import LogManager
import RxRelay
import RxSwift
import Utility

public final class FruitDrawViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    deinit {
        LogManager.printDebug("❌:: \(Self.self) deinit")
    }

    public init() {}

    public struct Input {
        let didTapFruitDraw: PublishSubject<Void> = PublishSubject()
        let endedLottieAnimation: PublishSubject<Void> = PublishSubject()
    }

    public struct Output {
        let dataSource: PublishRelay<String> = PublishRelay()
        let showToast: PublishSubject<String> = PublishSubject()
        let showRewardNote: PublishRelay<String> = PublishRelay()
    }

    public func transform(from input: Input) -> Output {
        let output = Output()

        input.didTapFruitDraw
            .flatMap { _ in
                // TO-DO: FruitDrawUseCase
                return Observable.just("")
            }
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)

        Observable.zip(input.endedLottieAnimation, output.dataSource)
            .subscribe()
            .disposed(by: disposeBag)

        return output
    }
}
