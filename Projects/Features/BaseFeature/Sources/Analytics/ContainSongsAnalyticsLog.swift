import LogManager

enum ContainSongsAnalyticsLog: AnalyticsLogType {
    case clickCreatePlaylistButton(location: CreatePlaylistLocation)
}

enum CreatePlaylistLocation: String, AnalyticsLogEnumParametable {
    case addMusics = "add-musics"

    var description: String {
        self.rawValue
    }
}
