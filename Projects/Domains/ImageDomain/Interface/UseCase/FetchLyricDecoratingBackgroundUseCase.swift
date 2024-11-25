import Foundation
import RxSwift

public protocol FetchLyricDecoratingBackgroundUseCase: Sendable {
    func execute() -> Single<[LyricDecoratingBackgroundEntity]>
}
