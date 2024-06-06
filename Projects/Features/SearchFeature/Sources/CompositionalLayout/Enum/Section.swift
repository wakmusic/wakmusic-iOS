import Foundation

internal enum Section: Int {
    case youtube
    case recommend
    case popularList
}

internal enum RecommendSection: Hashable {
    case main
}

internal enum IntegratedSearchResultSection: Hashable {
    case song
    case artist
    case remix
    case credit
    case list
    
    var title: String {
        
        switch self {
        
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
