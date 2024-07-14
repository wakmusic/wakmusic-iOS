import ErrorModule
import Moya

enum TokenRefreshAPI {
    case refresh
}

extension TokenRefreshAPI: WMAPI {
    var domain: WMDomain { .auth }

    var urlPath: String { "/token" }

    var method: Moya.Method { .post }

    var task: Moya.Task { .requestPlain }

    var jwtTokenType: JwtTokenType { .refreshToken }

    var errorMap: [Int: WMError] {
        [
            400: .badRequest,
            401: .tokenExpired,
            404: .notFound,
            429: .tooManyRequest,
            500: .internalServerError
        ]
    }
}
