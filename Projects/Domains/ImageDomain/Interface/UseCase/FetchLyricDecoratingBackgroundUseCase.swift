import Foundation
import RxSwift

public protocol FetchLyricDecoratingBackgroundUseCase {
    func execute() -> Single<[LyricDecoratingBackgroundEntity]>
}
