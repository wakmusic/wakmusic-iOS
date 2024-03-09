import DataMappingModule
import ErrorModule
import Foundation
import Moya

public enum ChartAPI {
    case fetchChartRanking(type: ChartDateType, limit: Int)
    case fetchChartUpdateTime(type: ChartDateType)
}

extension ChartAPI: WMAPI {
    public var domain: WMDomain {
        .charts
    }

    public var urlPath: String {
        switch self {
        case .fetchChartRanking:
            return "/"
        case let .fetchChartUpdateTime(type):
            return "/updated/\(type.rawValue)"
        }
    }

    public var method: Moya.Method {
        return .get
    }

    public var task: Moya.Task {
        switch self {
        case let .fetchChartRanking(type, limit):
            return .requestParameters(parameters: [
                "type": type.rawValue,
                "limit": limit
            ], encoding: URLEncoding.queryString)

        case .fetchChartUpdateTime:
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
