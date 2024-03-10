import ErrorModule
import Foundation
import KeychainModule
import Moya
import BaseDomain

public enum LikeAPI {
    case fetchLikeNumOfSong(id: String)
    case addLikeSong(id: String)
    case cancelLikeSong(id: String)
}

extension LikeAPI: WMAPI {
    public var domain: WMDomain {
        .like
    }

    public var urlPath: String {
        switch self {
        case let .fetchLikeNumOfSong(id: id):
            return "/\(id)"
        case let .addLikeSong(id: id):
            return "/\(id)"
        case let .cancelLikeSong(id: id):
            return "/\(id)"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .fetchLikeNumOfSong:
            return .get
        case .addLikeSong:
            return .post
        case .cancelLikeSong:
            return .delete
        }
    }

    public var task: Moya.Task {
        return .requestPlain
    }

    public var jwtTokenType: JwtTokenType {
        switch self {
        case .fetchLikeNumOfSong:
            return .none
        case .addLikeSong, .cancelLikeSong:
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
