import Foundation
import RxSwift
import SearchFeatureInterface

protocol SearchCommonService {
    var typingStatus: BehaviorSubject<TypingStatus> { get }
    var recentText: PublishSubject<String> { get }
}

final class DefaultSearchCommonService: SearchCommonService {
    let typingStatus: BehaviorSubject<TypingStatus> = .init(value: .before)

    let recentText: PublishSubject<String> = .init()

    static let shared = DefaultSearchCommonService()
}
