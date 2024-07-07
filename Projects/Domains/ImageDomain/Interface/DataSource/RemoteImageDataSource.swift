import Foundation
import RxSwift

public protocol RemoteImageDataSource {
    func fetchLyricDecoratingBackground() -> Single<[LyricDecoratingBackgroundEntity]>
    func fetchProfileList() -> Single<[ProfileListEntity]>
    func fetchDefaultPlaylistImage() -> Single<[DefaultImageEntity]>
}
