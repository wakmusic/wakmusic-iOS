import Foundation
import RxSwift

public protocol SearchGlobalScrollPortocol {
    var scrollAmountObservable: Observable<CGFloat> { get }
    var expandSearchHeaderObservable: Observable<Void> { get }

    func scrollTo(amount: CGFloat)
    func expand()
}

public final class SearchGlobalScrollState: SearchGlobalScrollPortocol {
    private let scrollAmountSubject = PublishSubject<CGFloat>()
    private let expandSearchHeaderSubject = PublishSubject<Void>()

    public init() {}

    public var scrollAmountObservable: Observable<CGFloat> {
        scrollAmountSubject
    }

    public func scrollTo(amount: CGFloat) {
        scrollAmountSubject.onNext(amount)
    }

    public var expandSearchHeaderObservable: Observable<Void> {
        expandSearchHeaderSubject
    }

    public func expand() {
        expandSearchHeaderSubject.onNext(())
    }
}
