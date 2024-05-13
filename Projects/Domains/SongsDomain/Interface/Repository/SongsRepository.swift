import Foundation
import RxSwift

public protocol SongsRepository {
    func fetchSearchSong(keyword: String) -> Single<SearchResultEntity>
    func fetchLyrics(id: String) -> Single<[LyricsEntity]>
    func fetchSongCredits(id: String) -> Single<SongCreditsEntity>
    func fetchNewSongs(type: NewSongGroupType, page: Int, limit: Int) -> Single<[NewSongsEntity]>
}
