import LogManager

enum ContainSongsAnalyticsLog: AnalyticsLogType {
    case clickCreatePlaylistButton(location: CreatePlaylistLocation)
    case completeAddMusics(playlistId: String, count: Int)
}

enum CreatePlaylistLocation: String, AnalyticsLogEnumParametable {
    case addMusics = "add_musics"

    var description: String {
        self.rawValue
    }
}
