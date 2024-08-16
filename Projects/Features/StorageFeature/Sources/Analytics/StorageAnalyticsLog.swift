import LogManager

enum StorageAnalyticsLog: AnalyticsLogType {
    case clickStorageTabbarTab(tab: StorageTab)
    case clickCreatePlaylistButton(location: CreatePlaylistLocation)
    case clickMyPlaylistEditButton
    case clickMyLikeListEditButton
    case clickLoginButton(location: LoginLocation)
    
    case clickFruitDrawEntryButton(location: FruitDrawEntryLocation)
}

enum StorageTab: String, CustomStringConvertible {
    case myPlaylist = "my-playlist"
    case myLikeList = "my-like-list"
    
    var description: String {
        self.rawValue
    }
}

enum CreatePlaylistLocation: String, CustomStringConvertible {
    case myPlaylist = "my-playlist"
    
    var description: String {
        self.rawValue
    }
}

enum FruitDrawEntryLocation: String, CustomStringConvertible {
    case myPlaylist = "my-playlist"

    var description: String {
        self.rawValue
    }
}

enum LoginLocation: String, CustomStringConvertible {
    case myPlaylist = "my-playlist"
    case myLikeList = "my-like-list"
    case addMusics = "add-musics"

    var description: String {
        self.rawValue
    }
}

/*
 보관함 화면 보여짐 (내리스트, 좋아요) // common
 
 내 리스트 탭 클릭함
 좋아요 탭 클릭함
 
 내 리스트 - 리스트 만들기 클릭함
 내 리스트 - 리스트 클릭함 (id) // common
 내 리스트 - 플레이버튼 클릭함 (id) // common
 내 리스트 - 편집 버튼 클릭함
 내 리스트 - 열매 뽑기 버튼 클릭함
 내 리스트 - 로그인 버튼 클릭함
 내 리스트 - 리스트 만들기 - 로그인 버튼 클릭함
 
 좋아요 탭 - 곡 클릭함 (id)
 좋아요 탭 - 플레이버튼 클릭함 (id) // common
 좋아요 탭 - 편집 버튼 클릭함
 좋아요 탭 - 로그인 버튼 클릭함
 */
