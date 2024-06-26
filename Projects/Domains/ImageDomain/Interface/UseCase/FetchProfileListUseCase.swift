import Foundation
import RxSwift

public protocol FetchProfileListUseCase {
    func execute() -> Single<[ProfileListEntity]>
}
