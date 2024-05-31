import Foundation

public enum CommonAnalyticsLog: AnalyticsLogType {
    case viewPage(pageName: PageName)
    case clickPlaylistItem(location: PlaylistItemLocation)
}

public extension CommonAnalyticsLog {
    enum PageName: String, CustomStringConvertible {
        case home
        case musicDetail = "music_detail"
        case musicLyrics = "music_lyrics"
        case recentMusic = "recent_music"
        case chart
        case artist
        case storage
        case search
        case fruitDraw = "fruit_draw" // 열매 뽑기
        case playlist
        case mypage
        case setting
        case login

        public var description: String {
            self.rawValue
        }
    }

    public enum PlaylistItemLocation: String, CustomStringConvertible {
        case home
        case storage
        case search

        public var description: String {
            self.rawValue
        }
    }
}
