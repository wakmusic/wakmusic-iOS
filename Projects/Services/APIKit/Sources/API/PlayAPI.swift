import DataMappingModule
import ErrorModule
import Foundation
import KeychainModule
import Moya

public enum PlayAPI {
    case postPlaybackLog(item: Data)
}

extension PlayAPI: WMAPI {
    public var domain: WMDomain {
        return .play
    }

    public var urlPath: String {
        switch self {
        case .postPlaybackLog:
            return ""
        }
    }

    public var method: Moya.Method {
        switch self {
        case .postPlaybackLog:
            return .post
        }
    }

    public var task: Moya.Task {
        switch self {
        case let .postPlaybackLog(item):
            return .requestData(item)
        }
    }

    public var jwtTokenType: JwtTokenType {
        return .accessToken
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
