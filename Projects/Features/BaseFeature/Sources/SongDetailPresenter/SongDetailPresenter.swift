import Foundation
import RxSwift

public protocol SongDetailPresentable {
    var presentSongDetailObservable: Observable<(ids: [String], selectedID: String)> { get }
    func present(id: String)
    func present(ids: [String], selectedID: String)
}

public final class SongDetailPresenter: SongDetailPresentable {
    private let presentSongDetailSubject = PublishSubject<(ids: [String], selectedID: String)>()
    public var presentSongDetailObservable: Observable<(ids: [String], selectedID: String)> {
        presentSongDetailSubject
    }

    public func present(id: String) {
        presentSongDetailSubject.onNext(([id], id))
    }

    public func present(ids: [String], selectedID: String) {
        presentSongDetailSubject.onNext((ids, selectedID))
    }

    public init() {}
}
