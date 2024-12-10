import Foundation
import RxSwift

public protocol RemoteTeamDataSource: Sendable {
    func fetchTeamList() -> Single<[TeamListEntity]>
}
