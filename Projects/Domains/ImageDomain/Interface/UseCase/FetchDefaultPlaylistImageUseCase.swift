import Foundation
import RxSwift

public protocol FetchDefaultPlaylistImageUseCase: Sendable {
    func execute() -> Single<[DefaultImageEntity]>
}
