import Foundation
import RxSwift

public protocol FetchNoticeCategoriesUseCase: Sendable {
    func execute() -> Single<FetchNoticeCategoriesEntity>
}
