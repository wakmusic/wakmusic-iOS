import BaseDomain
import ErrorModule
import Foundation
import ImageDomainInterface
import Moya

public enum ImageAPI {
    case fetchLyricDecoratingBackground
}

extension ImageAPI: WMAPI {
    public var domain: WMDomain {
        return .image
    }

    public var urlPath: String {
        switch self {
        case .fetchLyricDecoratingBackground:
            return "/lyrics/backgrounds"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .fetchLyricDecoratingBackground:
            return .get
        }
    }

    public var task: Moya.Task {
        switch self {
        case .fetchLyricDecoratingBackground:
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
