import Moya
import DataMappingModule
import ErrorModule
import Foundation
import Utility

public enum AppAPI {
    case checkVersion
}

extension AppAPI: WMAPI {

    public var domain: WMDomain {
        .app
    }

    public var urlPath: String {
        switch self {
            case .checkVersion:
                return "/version"
        }
    }
        
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Moya.Task {
        switch self {
            
        case .checkVersion:
            return .requestParameters(parameters: [
                "os": "ios",
                "version": APP_VERSION()
            ], encoding: URLEncoding.queryString)
            
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
