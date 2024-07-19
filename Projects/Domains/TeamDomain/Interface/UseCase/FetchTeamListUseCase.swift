import Foundation
import RxSwift

public protocol FetchTeamListUseCase {
    func execute() -> Single<[TeamListEntity]>
}
