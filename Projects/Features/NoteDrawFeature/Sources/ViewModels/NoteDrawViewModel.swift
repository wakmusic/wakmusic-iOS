import BaseFeature
import Foundation
import LogManager
import RxRelay
import RxSwift
import Utility

#warning("Required NoteDraw UseCase")
public final class NoteDrawViewModel: ViewModelType {
    private let disposeBag = DisposeBag()

    deinit {
        LogManager.printDebug("❌:: \(Self.self) deinit")
    }

    public init() {}

    public struct Input {
        let didTapNoteDraw: PublishSubject<Void> = PublishSubject()
        let endedLottieAnimation: PublishSubject<Void> = PublishSubject()
    }

    public struct Output {
        let dataSource: PublishRelay<String> = PublishRelay()
        let showToast: PublishSubject<String> = PublishSubject()
    }

    public func transform(from input: Input) -> Output {
        let output = Output()

        input.didTapNoteDraw
            .flatMap { _ in
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
