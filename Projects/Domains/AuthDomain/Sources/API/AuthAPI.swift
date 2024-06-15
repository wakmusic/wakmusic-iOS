import AuthDomainInterface
import BaseDomain
import ErrorModule
import Foundation
import Moya

public enum AuthAPI {
    case fetchToken(providerType: ProviderType, token: String)
    case fetchNaverUserInfo(tokenType: String, accessToken: String)
}

private struct FetchTokenRequestParameters: Encodable {
    var provider: String
    var token: String
}

extension AuthAPI: WMAPI {
    public var baseURL: URL {
        switch self {
        case .fetchToken:
            return URL(string: BASE_URL())!
        case .fetchNaverUserInfo:
            return URL(string: "https://openapi.naver.com")!
        }
    }

    public var domain: WMDomain {
        switch self {
        case .fetchToken:
            return .auth
        case .fetchNaverUserInfo:
            return .naver
        }
    }

    public var urlPath: String {
        switch self {
        case .fetchToken:
            return "/app"
        case .fetchNaverUserInfo:
            return ""
        }
    }

    public var method: Moya.Method {
        switch self {
        case .fetchToken:
            return .post
        case .fetchNaverUserInfo:
            return .get
        }
    }

    public var headers: [String: String]? {
        switch self {
        case let .fetchNaverUserInfo(tokenType, accessToken):
            return ["Authorization": "\(tokenType) \(accessToken)"]
        default:
            return ["Content-Type": "application/json"]
        }
    }

    public var task: Moya.Task {
        switch self {
        case let .fetchToken(providerType: providerType, token: id):
            return .requestJSONEncodable(
                FetchTokenRequestParameters(
                    provider: providerType.rawValue,
                    token: id
                )
            )
        case .fetchNaverUserInfo:
            return .requestPlain
        }
    }

    public var jwtTokenType: JwtTokenType {
        switch self {
        default:
            return .none
        }
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
