public enum FilterType: String, Encodable {
    case all
    case title
    case artist
    case credit

    public var title: String {
        switch self {
        case .all:
            "전체"
        case .title:
            "제목"
        case .artist:
            "아티스트"
        case .credit:
            "크레딧"
        }
    }
}

public enum SortType: String, Encodable {
    case latest
    case oldest
    case likes
    case views
    case alphabetical

    public var title: String {
        switch self {
        case .latest:
            "최신순"
        case .oldest:
            "과거순"
        case .likes:
            "좋아요순"
        case .views:
            "조회수순"
        case .alphabetical:
            "가나다순"
        }
    }
}
