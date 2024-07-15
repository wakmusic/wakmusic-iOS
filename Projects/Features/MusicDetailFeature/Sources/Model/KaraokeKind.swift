import Foundation


enum KaraokeKind {
    case KY
    case TJ
    
    
    var koreanTitle: String {
        switch self {
        case .KY:
            "금영"
        case .TJ:
            "태진"
        }
    }
    
}
