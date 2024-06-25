import BaseDomain
import BaseDomainInterface
import ErrorModule
import Foundation
import KeychainModule
import Moya
import PlaylistDomainInterface

public struct AddSongRequest: Encodable {
    var songIds: [String]
}

public struct CreatePlayListRequset: Encodable {
    var title: String
}

public struct SongsKeyBody: Encodable {
    var songIds: [String]
}

public struct TitleAndPrivateRequset: Encodable {
    var title: String?
    var `private`: Bool?
}

public enum PlaylistAPI {
    case fetchRecommendPlayList // 추천 플리 불러오기
    case fetchPlayListDetail(id: String, type: PlaylistType) // 플리 상세 불러오기
    case updateTitleAndPrivate(key: String, title: String?, isPrivate: Bool?) // title and private 업데이트
    case createPlayList(title: String) // 플리 생성
    case fetchPlaylistSongs(key: String) // 전체 재생 시 곡 데이터만 가져오기
    case addSongIntoPlayList(key: String, songs: [String]) // 곡 추가
    case updatePlaylist(key: String, songs: [String]) // 최종 저장
    case removeSongs(key: String, songs: [String]) // 곡 삭제
    case uploadImage(key: String, model: UploadImageType) // 플레이리스트 이미지 업로드
}

extension PlaylistAPI: WMAPI {
    public var domain: WMDomain {
        .playlist
    }

    public var urlPath: String {
        switch self {
        case .fetchRecommendPlayList:
            return "/recommend/list"

        case let .fetchPlayListDetail(id: id, type: type):
            switch type {
            case .custom:
                return "/\(id)"
            case .wmRecommend:
                return "/recommend/\(id)"
            }

        case let .updateTitleAndPrivate(key: key, _, _):
            return "/\(key)"

        case .createPlayList:
            return "/create"

        case let .fetchPlaylistSongs(key: key), let .addSongIntoPlayList(key: key, _), let .updatePlaylist(key: key, _),
             let .removeSongs(key: key, _):
            return "/\(key)/songs"

        case let .uploadImage(key: key, _):
            return "/\(key)/image"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .fetchRecommendPlayList, .fetchPlayListDetail, .fetchPlaylistSongs:
            return .get

        case .createPlayList, .addSongIntoPlayList:
            return .post

        case .removeSongs:
            return .delete

        case .updatePlaylist, .updateTitleAndPrivate, .uploadImage:
            return .patch
        }
    }

    public var task: Moya.Task {
        switch self {
        case .fetchRecommendPlayList, .fetchPlayListDetail, .fetchPlaylistSongs:
            return .requestPlain

        case let .updateTitleAndPrivate(_, title: title, isPrivate: isPrivate):
            return .requestJSONEncodable(TitleAndPrivateRequset(title: title, private: isPrivate))

        case let .createPlayList(title: title):
            return .requestJSONEncodable(CreatePlayListRequset(title: title))

        case let .addSongIntoPlayList(_, songs: songs):
            return .requestJSONEncodable(AddSongRequest(songIds: songs))

        case let .updatePlaylist(_, songs: songs):
            return .requestJSONEncodable(SongsKeyBody(songIds: songs))

        case let .removeSongs(_, songs: songs):
            return .requestParameters(
                parameters: ["songIds": songs.joined(separator: ",")],
                encoding: URLEncoding.queryString
            )

        case let .uploadImage(_, model: model):

            var datas: [MultipartFormData] = []

            switch model {
            case let .default(imageName: data):
                datas.append(MultipartFormData(
                    provider: .data("default".data(using: .utf8)!), name: "type"
                ))

                datas.append(MultipartFormData(provider: .data(data.data(using: .utf8)!), name: "imageName"))

            case let .custom(imageName: data):
                datas.append(MultipartFormData(provider: .data("custom".data(using: .utf8)!), name: "type"))
                datas.append(MultipartFormData(
                    provider: .data(data),
                    name: "imageFile",
                    fileName: "image.jpeg"
                ))
            }
            return .uploadMultipart(datas)
        }
    }

    public var headers: [String: String]? {
        switch self {
        case .uploadImage:

            return ["Content-Type": "multipart/form-data"]

        default:
            return ["Content-Type": "application/json"]
        }
    }

    public var jwtTokenType: JwtTokenType {
        switch self {
        case .fetchRecommendPlayList, .fetchPlayListDetail, .fetchPlaylistSongs:
            return .none

        case .createPlayList, .updatePlaylist, .addSongIntoPlayList,
             .removeSongs, .updateTitleAndPrivate, .uploadImage:
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
