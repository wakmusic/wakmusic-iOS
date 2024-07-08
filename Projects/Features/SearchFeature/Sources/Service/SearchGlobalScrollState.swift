import Foundation
import RxSwift

public protocol SearchGlobalScrollPortocol {
    var scrollAmountObservable: Observable<CGFloat> { get }

    func scrollTo(amount: CGFloat)

}

public final class SearchGlobalScrollState: SearchGlobalScrollPortocol {
    
    private let scrollAmountSubject = PublishSubject<CGFloat>()

    
    public init() {}

    public var scrollAmountObservable: Observable<CGFloat> {
        scrollAmountSubject
    }

    public func scrollTo(amount: CGFloat) {
        scrollAmountSubject.onNext(amount)
    }
    

}
