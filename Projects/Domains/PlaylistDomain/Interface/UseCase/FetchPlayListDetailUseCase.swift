import Foundation
import RxSwift

public protocol FetchPlayListDetailUseCase {
    func execute(id: String, type: PlayListType) -> Single<PlayListDetailEntity>
}
