import Foundation
import RxSwift

public protocol SongsRepository {
    func fetchSong(id: String) -> Single<SongEntity>
    func fetchLyrics(id: String) -> Single<LyricsEntity>
    func fetchSongCredits(id: String) -> Single<[SongCreditsEntity]>
    func fetchNewSongs(type: NewSongGroupType, page: Int, limit: Int) -> Single<[NewSongsEntity]>
    func fetchNewSongsPlaylist(type: NewSongGroupType) -> Single<NewSongsPlaylistEntity>
}
