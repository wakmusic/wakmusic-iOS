public enum TabPosition: Int {
    case all = 0
    case song
    case artist
    case remix
    case credit
    case list

    var title: String {
        switch self {
        case .all:
            "통합검색"
        case .song:
            "곡"
        case .artist:
            "아티스트"
        case .remix:
            "조교"
        case .credit:
            "크레딧"
        case .list:
            "리스트"
        }
    }
}

public enum TypingStatus {
    case before
    case typing
    case search
}
