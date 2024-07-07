import Foundation
import RxSwift

public protocol FetchDefaultPlaylistImageUseCase {
    func execute() -> Single<[DefaultImageEntity]>
}
