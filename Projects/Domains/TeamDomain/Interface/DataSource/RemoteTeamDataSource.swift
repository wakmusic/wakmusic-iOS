import Foundation
import RxSwift

public protocol RemoteTeamDataSource {
    func fetchTeamList() -> Single<[TeamListEntity]>
}
