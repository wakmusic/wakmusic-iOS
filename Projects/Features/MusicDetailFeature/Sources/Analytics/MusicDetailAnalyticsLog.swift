import LogManager

enum MusicDetailAnalyticsLog: AnalyticsLogType {
    case clickCreditButton(key: String, id: String)
    case clickPrevMusicButton(key: String, id: String)
    case clickNextMusicButton(key: String, id: String)
    case clickSingingRoomButton(key: String, id: String)
    case clickLyricsButton(key: String, id: String)
    case clickLikeMusicButton(key: String, id: String, like: Bool)
    case clickMusicPickButton(key: String, id: String)
    case clickPlaylistButton(key: String, id: String)
}
