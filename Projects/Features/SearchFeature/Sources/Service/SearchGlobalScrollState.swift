import Foundation
import RxSwift

public protocol SearchGlobalScrollPortocol {
    var scrollAmountObservable: Observable<CGFloat> { get }

    func scrollTo(_ amount: CGFloat)
}

public final class SearchGlobalScrollState: SearchGlobalScrollPortocol {
    private let scrollAmountSubject = PublishSubject<CGFloat>()

    public init() {}

    public var scrollAmountObservable: Observable<CGFloat> {
        scrollAmountSubject
    }

    public func scrollTo(_ amount: CGFloat) {
        scrollAmountSubject.onNext(amount)
    }
}
