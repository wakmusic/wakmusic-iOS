import BaseDomain
import ChartDomainInterface
import ErrorModule
import Foundation
import Moya

public enum ChartAPI {
    case fetchChartRanking(type: ChartDateType)
    case fetchCurrentVideo
}

extension ChartAPI: WMAPI {
    public var domain: WMDomain {
        .charts
    }

    public var urlPath: String {
        switch self {
        case let .fetchChartRanking(type):
            return "/\(type.rawValue)"

        case .fetchCurrentVideo:
            return "/current-video"
        }
    }

    public var method: Moya.Method {
        return .get
    }

    public var task: Moya.Task {
        switch self {
        case .fetchChartRanking, .fetchCurrentVideo:
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
