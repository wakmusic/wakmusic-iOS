import Moya
import DataMappingModule
import ErrorModule
import Foundation
import KeychainModule

public enum QnaAPI {
  
    case fetchQnaCategories
    case fetchQna
    
}



extension QnaAPI: WMAPI {

    public var domain: WMDomain {
        .qna
    }

    public var urlPath: String {
        switch self {
            
        case .fetchQnaCategories:
            return "/categories"
        
        case .fetchQna:
            return "/"
            
        }
        
            
    }
        
    public var method: Moya.Method {
        switch self {
        case .fetchQnaCategories,.fetchQna:
            return .get
            
        }
    }
    
    public var task: Moya.Task {
        switch self {
            
            
        case .fetchQnaCategories,.fetchQna:
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
