import Foundation
import RxSwift

public protocol TeamRepository: Sendable {
    func fetchTeamList() -> Single<[TeamListEntity]>
}
