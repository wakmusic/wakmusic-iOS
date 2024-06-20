import Foundation
import RxSwift

public protocol FetchDecoratingBackgroundUseCase {
    func execute() -> Single<[DecoratingBackgroundEntity]>
}
