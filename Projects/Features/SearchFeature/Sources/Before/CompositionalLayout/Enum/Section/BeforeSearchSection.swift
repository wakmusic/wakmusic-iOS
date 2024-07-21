import Foundation

internal enum BeforeSearchSection: Int {
    case youtube
    case recommend
    case popularList

    var title: String {
        switch self {
        case .youtube:
            return ""
        case .recommend:
            return "왁뮤팀이 추천하는 리스트"
        case .popularList:
            return "인기 리스트"
        }
    }
}
