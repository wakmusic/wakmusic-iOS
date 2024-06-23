import Foundation
import RxSwift

public protocol ImageRepository {
    func fetchLyricDecoratingBackground() -> Single<[LyricDecoratingBackgroundEntity]>
}
