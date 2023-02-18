import Moya
import DataMappingModule
import ErrorModule
import Foundation



public struct CreatePlayListRequset:Encodable {
    var title:String
    var image:String
}

public struct EditPlayListRequset:Encodable {
    var title:String
    var songs:[String]
}


public enum PlayListAPI {
    case fetchRecommendPlayList
    case fetchPlayListDetail(id:String,type:PlayListType)
    case createPlayList(title:String)
    case editPlayList(key:String,title:String,songs:[String])
}

extension PlayListAPI: WMAPI {
    public var domain: WMDomain {
        .playlist
    }

    public var urlPath: String {
        switch self {
            
        case .fetchRecommendPlayList:
            return "/recommended"
            
            
        case .fetchPlayListDetail(id: let id, type: let type):
            
            switch type {
                
            case .custom:
                return "/\(id)/detail"
            case .wmRecommend:
                return "/recommended/\(id)"
            }
            
        case .createPlayList:
            return "/create"
       
        case .editPlayList(key: let key):
            return "/\(key)/edit"
        }
    }
        
        public var method: Moya.Method {
            
            switch self {
                
            case .fetchRecommendPlayList,.fetchPlayListDetail:
                return .get
            
            case .createPlayList:
                return .post
            case .editPlayList:
                return .patch
            }
            
        }
    
        public var headers: [String : String]? {
            
            let token = ""
            
            switch self {
                
            case .fetchRecommendPlayList,.fetchPlayListDetail:
                return ["Content-Type": "application/json"]
                
            case .createPlayList,.editPlayList:
                return ["Authorization":"Bearer \(token)"]
            }
        }
    
        
        public var task: Moya.Task {
            switch self {
            case .fetchRecommendPlayList:
                return .requestPlain
                
            case .fetchPlayListDetail:
                return .requestPlain
                
                
            case .createPlayList(title: let title):
                return .requestJSONEncodable(CreatePlayListRequset(title: title, image: String(Int.random(in: 1...11))))
                
                
                
            case .editPlayList(_,title: let title, songs: let songs):
                return .requestJSONEncodable(EditPlayListRequset(title: title, songs: songs))
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
