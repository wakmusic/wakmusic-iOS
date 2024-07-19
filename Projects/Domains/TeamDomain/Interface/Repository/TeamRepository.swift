import Foundation
import RxSwift

public protocol TeamRepository {
    func fetchTeamList() -> Single<[TeamListEntity]>
}
