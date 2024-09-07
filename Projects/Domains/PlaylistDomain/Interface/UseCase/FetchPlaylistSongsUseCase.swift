import BaseDomainInterface
import Foundation
import RxSwift
import SongsDomainInterface

public protocol FetchPlaylistSongsUseCase {
    func execute(key: String) -> Single<[SongEntity]>
}
