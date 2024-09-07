import BaseDomain
import ErrorModule
import Foundation
import KeychainModule
import Moya

public enum LikeAPI {
    case addLikeSong(id: String)
    case cancelLikeSong(id: String)
    case checkIsLikedSong(id: String)
}

extension LikeAPI: WMAPI {
    public var domain: WMDomain {
        .like
    }

    public var urlPath: String {
        switch self {
        case let .addLikeSong(id: id):
            return "/\(id)"
        case let .cancelLikeSong(id: id):
            return "/\(id)"
        case let .checkIsLikedSong(id):
            return "/\(id)"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .addLikeSong:
            return .post
        case .cancelLikeSong:
            return .delete
        case .checkIsLikedSong:
            return .get
        }
    }

    public var task: Moya.Task {
        return .requestPlain
    }

    public var jwtTokenType: JwtTokenType {
        switch self {
        case .addLikeSong, .cancelLikeSong, .checkIsLikedSong:
            return .accessToken
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
