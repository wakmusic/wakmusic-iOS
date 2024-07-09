import Foundation
import RxSwift

public protocol SearchGlobalScrollPortocol {
    var scrollAmountObservable: Observable<(CGFloat, CGFloat)> { get }
    var expandSearchHeaderObservable: Observable<Void> { get }

    func scrollTo(source: (CGFloat, CGFloat))
    func expand()
}

public final class SearchGlobalScrollState: SearchGlobalScrollPortocol {
    private let scrollAmountSubject = PublishSubject<(CGFloat, CGFloat)>()
    private let expandSearchHeaderSubject = PublishSubject<Void>()

    public init() {}

    public var scrollAmountObservable: Observable<(CGFloat, CGFloat)> {
        scrollAmountSubject
    }

    public func scrollTo(source: (CGFloat, CGFloat)) {
        scrollAmountSubject.onNext(source)
    }

    public var expandSearchHeaderObservable: Observable<Void> {
        expandSearchHeaderSubject
    }

    public func expand() {
        expandSearchHeaderSubject.onNext(())
    }
}
