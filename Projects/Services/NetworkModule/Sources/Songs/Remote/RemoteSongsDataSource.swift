import DataMappingModule
import ErrorModule
import DomainModule
import RxSwift
import Foundation

public protocol RemoteSongsDataSource {
    func fetchSearchSong(type: SearchType,keyword: String) -> Single<[SongEntity]>
    func fetchLyrics(id: String) -> Single<[LyricsEntity]>
    func fetchNewSongs(type: NewSongGroupType, page: Int, limit: Int) -> Single<[NewSongsEntity]>
}
