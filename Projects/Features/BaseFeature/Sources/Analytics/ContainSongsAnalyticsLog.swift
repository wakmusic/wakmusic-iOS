import LogManager

enum ContainSongsAnalyticsLog: AnalyticsLogType {
    case clickCreatePlaylistButton(location: CreatePlaylistLocation)
}

enum CreatePlaylistLocation: String, CustomStringConvertible {
    case addMusics = "add-musics"
    
    var description: String {
        self.rawValue
    }
}
