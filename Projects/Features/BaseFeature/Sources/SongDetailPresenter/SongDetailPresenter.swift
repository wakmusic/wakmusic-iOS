import Foundation
import RxSwift

public protocol SongDetailPresentable {
    var presentSongDetailObservable: Observable<String> { get }
    func present(id: String)
}

public final class SongDetailPresenter: SongDetailPresentable {
    private let presentSongDetailSubject = PublishSubject<String>()
    public var presentSongDetailObservable: Observable<String> {
        presentSongDetailSubject
    }

    public func present(id: String) {
        presentSongDetailSubject.onNext(id)
    }

    public init() {}
}
