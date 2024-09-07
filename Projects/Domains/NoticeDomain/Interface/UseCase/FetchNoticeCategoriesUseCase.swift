import Foundation
import RxSwift

public protocol FetchNoticeCategoriesUseCase {
    func execute() -> Single<FetchNoticeCategoriesEntity>
}
