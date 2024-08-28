import Foundation
import RxSwift

public protocol PlayListPresenterGlobalStateProtocol {
    var presentPlayListObservable: Observable<String?> { get }

    func presentPlayList(currentSongID: String?)
    func presentPlayList()
}

public final class PlayListPresenterGlobalState: PlayListPresenterGlobalStateProtocol {
    private let presentPlayListSubject = PublishSubject<String?>()
    public var presentPlayListObservable: Observable<String?> {
        presentPlayListSubject
    }

    public init() {}

    public func presentPlayList(currentSongID: String?) {
        presentPlayListSubject.onNext(currentSongID)
    }

    public func presentPlayList() {
        presentPlayList(currentSongID: nil)
    }
}
