import Foundation
import RxSwift

protocol SearchCommonService {
    var typingStatus: BehaviorSubject<TypingStatus> { get }
    var recentText: PublishSubject<String> { get }
}

final class DefaultSearchCommonService: SearchCommonService {
    let typingStatus: BehaviorSubject<TypingStatus> = .init(value: .before)

    let recentText: RxSwift.PublishSubject<String> = .init()

    static let shared = DefaultSearchCommonService()
}
