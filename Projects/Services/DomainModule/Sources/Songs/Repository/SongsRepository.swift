import DataMappingModule
import ErrorModule
import Foundation
import RxSwift

public protocol SongsRepository {
    func fetchSearchSong(keyword: String) -> Single<SearchResultEntity>
    func fetchLyrics(id: String) -> Single<[LyricsEntity]>
    func fetchNewSongs(type: NewSongGroupType, page: Int, limit: Int) -> Single<[NewSongsEntity]>
}
