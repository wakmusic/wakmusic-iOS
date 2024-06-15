import Foundation
import RxSwift

public protocol PlayListPresenterGlobalStateProtocol {
    var presentPlayListObservable: Observable<Void> { get }

    func presentPlayList()
}

public final class PlayListPresenterGlobalState: PlayListPresenterGlobalStateProtocol {
    private let presentPlayListSubject = PublishSubject<Void>()
    public var presentPlayListObservable: Observable<Void> {
        presentPlayListSubject
    }

    public init() {}

    public func presentPlayList() {
        presentPlayListSubject.onNext(())
    }
}
