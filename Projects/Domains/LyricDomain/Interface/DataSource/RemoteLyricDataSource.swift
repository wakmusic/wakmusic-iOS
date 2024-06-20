import Foundation
import RxSwift

public protocol RemoteLyricDataSource {
    func fetchDecoratingBackground() -> Single<[DecoratingBackgroundEntity]>
}
