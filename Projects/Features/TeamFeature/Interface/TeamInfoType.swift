import Foundation

public enum TeamInfoType {
    case develop
    case weeklyWM

    var title: String {
        switch self {
        case .develop:
            return "개발팀"
        case .weeklyWM:
            return "주간 왁뮤팀"
        }
    }
}
