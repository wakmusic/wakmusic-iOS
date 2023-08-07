import Moya
import KeychainModule
import DataMappingModule
import ErrorModule
import Foundation


public struct AddSongRequest:Encodable {
    var songs:[String]
}

public struct CreatePlayListRequset:Encodable {
    var title:String
    var image:String
}

public struct SongsKeyBody:Encodable {
    var songs:[String]
}
public struct EditPlayListNameRequset:Encodable {
    var title:String
}


public enum PlayListAPI {
    case fetchRecommendPlayList
    case fetchPlayListDetail(id:String,type:PlayListType)
    case createPlayList(title:String)
    case editPlayList(key:String,songs:[String])
    case editPlayListName(key:String,title:String)
    case deletePlayList(key:String)
    case removeSongs(key:String,songs:[String])
    case loadPlayList(key:String)
    case addSongIntoPlayList(key:String,songs:[String])
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
        case .deletePlayList(key: let key):
            return "/\(key)/delete"
        case .loadPlayList(key: let key):
            return "/\(key)/addToMyPlaylist"
        case .editPlayList(key: let key,_):
            return "/\(key)/edit"
        case .editPlayListName(key: let key,_):
            return "/\(key)/edit/title"
        case .addSongIntoPlayList(key: let key,_):
            return "/\(key)/songs/add"
        case .removeSongs(key: let key,_):
            return "/\(key)/songs/remove"
        }
    }
        
    public var method: Moya.Method {
        switch self {
        case .fetchRecommendPlayList,.fetchPlayListDetail:
            return .get
        case .createPlayList,.loadPlayList,.addSongIntoPlayList:
            return .post
        case .editPlayList,.editPlayListName,.removeSongs:
            return .patch
        case .deletePlayList:
            return .delete
        }
    }
           
    public var task: Moya.Task {
        switch self {
        case .fetchRecommendPlayList:
            return .requestPlain
            
        case .fetchPlayListDetail,.deletePlayList,.loadPlayList:
            return .requestPlain
            
        case .createPlayList(title: let title):
            return .requestJSONEncodable(CreatePlayListRequset(title: title, image: String(Int.random(in: 1...11))))
            
        case .editPlayList(_,songs: let songs):
            return .requestJSONEncodable(SongsKeyBody(songs: songs))
            
        case .editPlayListName(_, title: let title):
            return .requestJSONEncodable(EditPlayListNameRequset(title: title))
            
        case . addSongIntoPlayList(_, songs: let songs):
            return .requestJSONEncodable(AddSongRequest(songs: songs))
            
        case .removeSongs(_, songs: let songs):
            return .requestJSONEncodable(SongsKeyBody(songs: songs))
        }
    }
            
    public var jwtTokenType: JwtTokenType {
        switch self {
        case .fetchRecommendPlayList,.fetchPlayListDetail:
            return .none
            
        case .createPlayList,.editPlayList,.deletePlayList,.loadPlayList,.editPlayListName,.addSongIntoPlayList,.removeSongs:
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
                409: .conflict,
                429: .tooManyRequest,
                500: .internalServerError
            ]
        }
    }
}
