import LogManager

enum StorageAnalyticsLog: AnalyticsLogType {
    case viewPage(pageName: String)
    case clickFruitDrawButton
    case clickMusicItem(location: MusicItemLocation, id: String)
    case clickMusicItemPlayButton(location: MusicItemLocation, id: String)
}

enum MusicItemLocation: String, CustomStringConvertible {
    case homeTop100 = "storage-like"
    case homeRecent = "home-recent"

    var description: String {
        self.rawValue
    }
}

/*
 내 리스트 탭 클릭함 click
 좋아요 탭 클릭함
 내 리스트 - 리스트 만들기 클릭함
 내 리스트 - 리스트 클릭함 (id)
 내 리스트 - 플레이버튼 클릭함 (id)
 좋아요 탭 - 곡 클릭함 (id)
 좋아요 탭 - 플레이버튼 클릭함 (id)
 */
