import Moya
import DataMappingModule
import ErrorModule
import Foundation

public enum AuthAPI {
    case fetchToken(id:String,type:ProviderType)
    
}

public struct AuthModel:Encodable {
    var id:String
    var provider:String
}

extension AuthAPI: WMAPI {
    public var domain: WMDomain {
        .auth
    }

    public var urlPath: String {
        
        switch self{
            
        case .fetchToken:
            return "/login/mobile"
        }
        
       
    }

    public var method: Moya.Method {
        
        switch self {
            
        case .fetchToken:
            return .post
        }
        
       
    }

    public var task: Moya.Task {
        
        switch self {
            
        case .fetchToken(id: let id, type: let type):
            return .requestJSONEncodable(AuthModel(id: id,provider: type.rawValue))
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
