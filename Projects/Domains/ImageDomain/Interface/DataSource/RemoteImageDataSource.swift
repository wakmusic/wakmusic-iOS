import Foundation
import RxSwift

public protocol RemoteImageDataSource {
    func fetchLyricDecoratingBackground() -> Single<[LyricDecoratingBackgroundEntity]>
}
