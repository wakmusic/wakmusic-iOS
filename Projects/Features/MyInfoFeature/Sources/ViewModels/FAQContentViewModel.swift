import BaseFeature
import FaqDomainInterface
import Foundation
import RxRelay
import RxSwift
import Utility

@available(
    *,
    deprecated,
    renamed: "FAQContentViewModel",
    message: "QnaContentViewModel is deprecated, use FAQContentViewModel instead."
)
typealias QnaContentViewModel = FAQContentViewModel

public final class FAQContentViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    var dataSource: [FaqEntity]

    public struct Input {}

    public struct Output {}

    public init(
        dataSource: [FaqEntity]
    ) {
        DEBUG_LOG("✅ \(Self.self) 생성")
        self.dataSource = dataSource
    }

    public func transform(from input: Input) -> Output {
        let output = Output()
        return output
    }
}
