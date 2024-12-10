import Foundation

public protocol AnalyticsLogEnumParametable: RawRepresentable, CustomStringConvertible
    where RawValue == String {}

public extension AnalyticsLogEnumParametable {
    var description: String {
        self.rawValue
    }
}

public enum CommonAnalyticsLog: AnalyticsLogType {
    case viewPage(pageName: PageName)
    case clickPlaylistItem(location: PlaylistItemLocation, key: String)
    case clickPlayButton(location: PlayButtonLocation, type: PlayButtonType)
    case clickAddMusicsButton(location: AddMusicLocation)
    case clickEditButton(location: EditButtonLocation)
    case clickEditCompleteButton(location: EditButtonLocation)
    case clickLoginButton(entry: LoginButtonEntry)
}

public extension CommonAnalyticsLog {
    enum PageName: String, AnalyticsLogEnumParametable, Sendable {
        case home
        case musicDetail = "music_detail"
        case musicLyrics = "music_lyrics"
        case recentMusic = "recent_music"
        case wakmusicRecommendPlaylist = "wakmusic_recommend_playlist"
        case wakmusicPlaylistDetail = "wakmusic_playlist_detail"
        case unknownPlaylistDetail = "unknown_playlist_detail"
        case myPlaylistDetail = "my_playlist_detail"
        case chart
        case artist
        case storagePlaylist = "storage_playlist"
        case storageLike = "storage_like"
        case search
        case fruitDraw = "fruit_draw" // 열매 뽑기
        case playlist
        case myPage = "my_page"
        case setting
        case login
        case songCredit = "song_credit"
        case creditSongList = "credit_song_list"
        case noticePopup = "notice_popup"

        public var description: String {
            self.rawValue
        }
    }

    enum PlaylistItemLocation: String, AnalyticsLogEnumParametable, Sendable {
        case home
        case storage
        case search
        case searchResult = "search_result"

        public var description: String {
            self.rawValue
        }
    }

    enum PlayButtonLocation: String, AnalyticsLogEnumParametable, Sendable {
        case home
        case search
        case artist
        case playlist
        case storagePlaylist = "storage_playlist"
        case storageLike = "storage_like"
        case playlistDetail = "playlist_detail"
        case chart
        case recentMusic = "recent_music"
        case musicDetail = "music_detail"
        case creditSongList = "credit_song_list"
    }

    enum PlayButtonType: String, AnalyticsLogEnumParametable, Sendable {
        case single
        case multiple
        case all
        case random
        case range1to50
        case range50to100
        case playlist
    }

    enum AddMusicLocation: String, AnalyticsLogEnumParametable, Sendable {
        case songDetail = "song_detail"
        case search
        case chart
        case recentMusic = "recent_music"
        case artist
        case playlist
        case playlistDetail = "playlist_detail"
        case storageLike = "storage_like"
    }

    enum EditButtonLocation: String, AnalyticsLogEnumParametable, Sendable {
        case playlistDetail = "playlist_detail"
        case myPlaylist = "my_playlist"
        case storageLike = "storage_like"
        case playlist
    }

    enum LoginButtonEntry: String, AnalyticsLogEnumParametable, Sendable {
        case myPlaylist = "my_playlist"
        case storageLike = "storage_like"
        case mypage
        case fruitStorage = "fruit_storage"
        case fruitDraw = "fruit_draw"
        case songLike = "song_like"
        case addMusics = "add_musics"
        case playlistSubscribe = "playlist_subscribe"
        case artistSubscribe = "artist_subscribe"
    }
}
