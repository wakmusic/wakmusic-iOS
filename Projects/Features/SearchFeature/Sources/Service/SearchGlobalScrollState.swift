import Foundation
import RxSwift

public enum SearchResultPage {
    case song
    case list
}

public protocol SearchGlobalScrollProtocol {
    var scrollAmountObservable: Observable<(CGFloat, CGFloat)> { get }
    var expandSearchHeaderObservable: Observable<Void> { get }

    var songResultScrollToTopObservable: Observable<Void> { get }
    var listResultScrollToTopObservable: Observable<Void> { get }

    func scrollTo(source: (CGFloat, CGFloat))
    func expand()
    func scrollToTop(page: SearchResultPage)
}

public final class SearchGlobalScrollState: SearchGlobalScrollProtocol {
    private let scrollAmountSubject = PublishSubject<(CGFloat, CGFloat)>()
    private let expandSearchHeaderSubject = PublishSubject<Void>()
    private let songResultScrollToTopSubject = PublishSubject<Void>()
    private let listResultScrollToTopSubject = PublishSubject<Void>()

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

    public var songResultScrollToTopObservable: Observable<Void> {
        songResultScrollToTopSubject
    }

    public var listResultScrollToTopObservable: Observable<Void> {
        listResultScrollToTopSubject
    }

    public func scrollToTop(page: SearchResultPage) {
        switch page {
        case .song:
            songResultScrollToTopSubject.onNext(())
        case .list:
            listResultScrollToTopSubject.onNext(())
        }
    }
}
