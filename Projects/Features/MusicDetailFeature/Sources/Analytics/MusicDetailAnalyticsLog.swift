import LogManager

enum MusicDetailAnalyticsLog: AnalyticsLogType {
    case clickCreditButton(id: String)
    case clickPrevMusicButton(id: String)
    case clickNextMusicButton(id: String)
    case clickSingingRoomButton(id: String)
    case clickLyricsButton(id: String)
    case clickLikeMusicButton(id: String, like: Bool)
    case clickPlaylistButton(id: String)
}
