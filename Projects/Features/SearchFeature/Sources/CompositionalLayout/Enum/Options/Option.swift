import Foundation

enum FilterType {
    case all
    case title
    case artist
    case credit

    var title: String {
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

enum SortType {
    case newest
    case oldest
    case likes
    case views
    case alphabeticalOrder

    var title: String {
        switch self {
        case .newest:
            "최신순"
        case .oldest:
            "과거순"
        case .likes:
            "좋아요순"
        case .views:
            "조회수순"
        case .alphabeticalOrder:
            "가나다순"
        }
    }
}
