import Foundation
import RxSwift

public protocol FetchTeamListUseCase: Sendable {
    func execute() -> Single<[TeamListEntity]>
}
