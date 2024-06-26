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
    }

    public struct Output {
        let showToast: PublishSubject<String> = PublishSubject()
    }

    public func transform(from input: Input) -> Output {
        let output = Output()
        return output
    }
}
