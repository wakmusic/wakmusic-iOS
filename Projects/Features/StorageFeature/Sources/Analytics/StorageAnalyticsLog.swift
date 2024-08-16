import LogManager

enum StorageAnalyticsLog: AnalyticsLogType {
    case clickStorageTabbarTab(tab: StorageTab)
    case clickCreatePlaylistButton(location: CreatePlaylistLocation)
    case clickMyPlaylistEditButton
    case clickMyLikeListEditButton
    case clickLoginButton(location: LoginLocation)
    case clickFruitDrawEntryButton(location: FruitDrawEntryLocation)
    case clickMyLikeListMusicButton(id: String)
}

enum StorageTab: String, AnalyticsLogEnumParametable {
    case myPlaylist = "my-playlist"
    case myLikeList = "my-like-list"

    var description: String {
        self.rawValue
    }
}

enum CreatePlaylistLocation: String, AnalyticsLogEnumParametable {
    case myPlaylist = "my-playlist"

    var description: String {
        self.rawValue
    }
}

enum FruitDrawEntryLocation: String, AnalyticsLogEnumParametable {
    case myPlaylist = "my-playlist"

    var description: String {
        self.rawValue
    }
}

enum LoginLocation: String, AnalyticsLogEnumParametable {
    case myPlaylist = "my-playlist"
    case myLikeList = "my-like-list"
    case addMusics = "add-musics"

    var description: String {
        self.rawValue
    }
}