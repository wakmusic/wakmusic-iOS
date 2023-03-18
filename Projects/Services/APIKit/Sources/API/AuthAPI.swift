import Moya
import DataMappingModule
import ErrorModule
import Foundation
import KeychainModule

public enum AuthAPI {
    case fetchToken(id:String,type:ProviderType)
    case fetchNaverUserInfo(tokenType:String,accessToken:String)
    case fetUserInfo
    case withdrawUserInfo
}

public struct AuthRequset:Encodable {
    var id:String
    var provider:String
}

extension AuthAPI: WMAPI {
    
    public var baseURL: URL {
        
        switch self {
        case .fetchToken,.fetUserInfo,.withdrawUserInfo:
            return URL(string: "https://test.wakmusic.xyz")!
        case .fetchNaverUserInfo:
            return URL(string: "https://openapi.naver.com")!
        }
    }
        
    public var domain: WMDomain {
        switch  self {
        case .fetchToken,.fetUserInfo,.withdrawUserInfo:
            return .auth
        case .fetchNaverUserInfo:
            return .naver
        }
    }

    public var urlPath: String {
        switch self {
        case .fetchToken:
            return "/login/mobile"
        case .fetchNaverUserInfo:
            return ""
        case .fetUserInfo:
            return "/"
        case .withdrawUserInfo:
            return "/remove"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .fetchToken:
            return .post
        case .fetchNaverUserInfo:
            return .get
        case .fetUserInfo:
             return .get
        case .withdrawUserInfo:
            return .delete
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .fetchNaverUserInfo(tokenType: let tokenType, accessToken: let accessToken):
            return   ["Authorization": "\(tokenType) \(accessToken)"]
        default:
            return ["Content-Type": "application/json"]
        }
    }

    public var task: Moya.Task {
        switch self {
        case .fetchToken(id: let id, type: let type):
            return .requestJSONEncodable(AuthRequset(id: id,provider: type.rawValue))
        case .fetchNaverUserInfo,.fetUserInfo,.withdrawUserInfo:
            return .requestPlain
        }
    }

    public var jwtTokenType: JwtTokenType {
        switch self {
        case .fetUserInfo, .withdrawUserInfo:
            return .accessToken
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
