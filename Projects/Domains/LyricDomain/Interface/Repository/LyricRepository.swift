import Foundation
import RxSwift

public protocol LyricRepository {
    func fetchDecoratingBackground() -> Single<[DecoratingBackgroundEntity]>
}
