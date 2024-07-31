import Foundation
import RxSwift

public protocol CheckIsLikedSongUseCase {
    func execute(id: String) -> Single<Bool>
}
