import DataMappingModule
import ErrorModule
import Foundation
import KeychainModule
import Moya

public struct AddSongRequest: Encodable {
    var songIds: [String]
}

public struct CreatePlayListRequset: Encodable {
    var title: String
    var image: String
}

public struct SongsKeyBody: Encodable {
    var songIds: [String]
}

public struct EditPlayListNameRequset: Encodable {
    var title: String
}

public enum PlayListAPI {
    case fetchRecommendPlayList
    case fetchPlayListDetail(id: String, type: PlayListType)
    case createPlayList(title: String)
    case editPlayList(key: String, songs: [String])
    case editPlayListName(key: String, title: String)
    case deletePlayList(key: String)
    case removeSongs(key: String, songs: [String])
    case loadPlayList(key: String)
    case addSongIntoPlayList(key: String, songs: [String])
}

extension PlayListAPI: WMAPI {
    public var domain: WMDomain {
        .playlist
    }

    public var urlPath: String {
        switch self {
        case .fetchRecommendPlayList:
            return "/recommended"

        case let .fetchPlayListDetail(id: id, type: type):
            switch type {
            case .custom:
                return "/\(id)"
            case .wmRecommend:
                return "/recommended/\(id)"
            }

        case .createPlayList:
            return "/create"

        case let .deletePlayList(key: key):
            return "/\(key)"

        case .loadPlayList:
            return "/copy"

        case let .editPlayList(key: key, _):
            return "/\(key)/songs"

        case let .editPlayListName(key: key, _):
            return "/\(key)"

        case let .addSongIntoPlayList(key: key, _):
            return "/\(key)/songs/add"

        case let .removeSongs(key: key, _):
            return "/\(key)/songs/remove"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .fetchRecommendPlayList, .fetchPlayListDetail:
            return .get

        case .createPlayList, .loadPlayList, .addSongIntoPlayList, .removeSongs:
            return .post

        case .editPlayList, .editPlayListName:
            return .patch

        case .deletePlayList:
            return .delete
        }
    }

    public var task: Moya.Task {
        switch self {
        case .fetchRecommendPlayList:
            return .requestPlain

        case .fetchPlayListDetail, .deletePlayList:
            return .requestPlain

        case let .loadPlayList(key):
            return .requestJSONEncodable(["key": key])

        case let .createPlayList(title: title):
            return .requestJSONEncodable(CreatePlayListRequset(title: title, image: String(Int.random(in: 1 ... 11))))

        case let .editPlayList(_, songs: songs):
            return .requestJSONEncodable(SongsKeyBody(songIds: songs))

        case let .editPlayListName(_, title: title):
            return .requestJSONEncodable(EditPlayListNameRequset(title: title))

        case let .addSongIntoPlayList(_, songs: songs):
            return .requestJSONEncodable(AddSongRequest(songIds: songs))

        case let .removeSongs(_, songs: songs):
            return .requestJSONEncodable(SongsKeyBody(songIds: songs))
        }
    }

    public var jwtTokenType: JwtTokenType {
        switch self {
        case .fetchRecommendPlayList, .fetchPlayListDetail:
            return .none

        case .createPlayList, .editPlayList, .deletePlayList, .loadPlayList, .editPlayListName, .addSongIntoPlayList,
             .removeSongs:
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
