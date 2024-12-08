public protocol SearchOptionType {
    var title: String { get }
}

public enum FilterType: String, Encodable, SearchOptionType, Sendable {
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

public enum SortType: String, Encodable, SearchOptionType, Sendable {
    case latest
    case oldest
    case relevance
    case popular

    public var title: String {
        switch self {
        case .latest:
            "최신순"
        case .oldest:
            "과거순"
        case .relevance:
            "관련도순"
        case .popular:
            "인기순"
        }
    }
}
