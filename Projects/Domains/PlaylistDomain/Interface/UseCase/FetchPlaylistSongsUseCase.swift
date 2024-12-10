import BaseDomainInterface
import Foundation
import RxSwift
import SongsDomainInterface

public protocol FetchPlaylistSongsUseCase: Sendable {
    func execute(key: String) -> Single<[SongEntity]>
}
