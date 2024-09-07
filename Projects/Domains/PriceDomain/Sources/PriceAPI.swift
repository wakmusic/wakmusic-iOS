import BaseDomain
import ErrorModule
import Foundation
import Moya
import TeamDomainInterface

public enum PriceAPI {
    case fetchPlaylistCreationPrice
    case fetchPlaylistImagePrice
}

extension PriceAPI: WMAPI {
    public var domain: WMDomain {
        return .price
    }

    public var urlPath: String {
        switch self {
        case .fetchPlaylistCreationPrice:
            return "/playlist/create"
        case .fetchPlaylistImagePrice:
            return "/playlist/custom-image"
        }
    }

    public var method: Moya.Method {
        return .get
    }

    public var task: Moya.Task {
        return .requestPlain
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
