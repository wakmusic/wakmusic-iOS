import Foundation
import RxSwift

public protocol ImageRepository {
    func fetchLyricDecoratingBackground() -> Single<[LyricDecoratingBackgroundEntity]>
    func fetchProfileList() -> Single<[ProfileListEntity]>
    func fetchDefaultPlaylistImage() -> Single<[DefaultImageEntity]>
}
