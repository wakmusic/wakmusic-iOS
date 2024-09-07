import BaseDomain
import ErrorModule
import Foundation
import Moya
import TeamDomainInterface

public enum TeamAPI {
    case fetchTeamList
}

extension TeamAPI: WMAPI {
    public var domain: WMDomain {
        return .team
    }

    public var urlPath: String {
        switch self {
        case .fetchTeamList:
            return "/list"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .fetchTeamList:
            return .get
        }
    }

    public var task: Moya.Task {
        switch self {
        case .fetchTeamList:
            return .requestPlain
        }
    }

    public var jwtTokenType: JwtTokenType {
        return .none
    }

    public var errorMap: [Int: WMError] {
        switch self {
        default:
            return [
                400: .badRequest,
                401: .tokenExpired,
                404: .notFound,
                429: .tooManyRequest,
                500: .internalServerError
            ]
        }
    }
}
