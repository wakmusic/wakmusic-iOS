import Foundation
import RxSwift

public protocol FetchProfileListUseCase: Sendable {
    func execute() -> Single<[ProfileListEntity]>
}
