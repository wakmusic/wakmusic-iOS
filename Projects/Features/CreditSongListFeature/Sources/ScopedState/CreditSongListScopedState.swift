import Foundation
import RxCocoa
import RxSwift
import UIKit

final class CreditSongListScopedState {
    static let shared = CreditSongListScopedState()

    private init() {}

    private let creditSongTabItemScrolledSubject = PublishSubject<UIScrollView>()
    var creditSongTabItemScrolledObservable: Observable<UIScrollView> {
        creditSongTabItemScrolledSubject
    }

    func didScroll(scrollView: UIScrollView) {
        creditSongTabItemScrolledSubject.onNext(scrollView)
    }
}
