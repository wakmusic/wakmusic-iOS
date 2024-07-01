import BaseDomain
import BaseDomainInterface
import ErrorModule
import Foundation
import KeychainModule
import Moya
import PlaylistDomainInterface

public enum PlaylistAPI {
    case fetchPlaylistDetail(id: String, type: PlaylistType) // 플리 상세 불러오기
    case updateTitleAndPrivate(key: String, title: String?, isPrivate: Bool?) // title and private 업데이트
    case createPlaylist(title: String) // 플리 생성
    case fetchPlaylistSongs(key: String) // 전체 재생 시 곡 데이터만 가져오기
    case addSongIntoPlaylist(key: String, songs: [String]) // 곡 추가
    case updatePlaylist(key: String, songs: [String]) // 최종 저장
    case removeSongs(key: String, songs: [String]) // 곡 삭제
    case uploadImage(key: String, model: UploadImageType) // 플레이리스트 이미지 업로드
    case subscribePlaylist(key: String, isSubscribing: Bool) // 플레이리스트 구독하기 / 구독 취소하기
    case checkSubscription(key: String)
    case fetchRecommendPlaylist // 추천 플리 불러오기
}

extension PlaylistAPI: WMAPI {
    public var domain: WMDomain {
        .playlist
    }

    public var urlPath: String {
        switch self {
        case .fetchRecommendPlaylist:
            return "/recommend/list"

        case let .fetchPlaylistDetail(id: id, type: type):
            switch type {
            case .unknown, .my:
                return "/\(id)"
            case .wmRecommend:
                return "/recommend/\(id)"
            }

        case let .updateTitleAndPrivate(key: key, _, _):
            return "/\(key)"

        case .createPlaylist:
            return "/create"

        case let .fetchPlaylistSongs(key: key), let .addSongIntoPlaylist(key: key, _), let .updatePlaylist(key: key, _),
             let .removeSongs(key: key, _):
            return "/\(key)/songs"

        case let .uploadImage(key: key, _):
            return "/\(key)/image"

        case let .subscribePlaylist(key, _), let .checkSubscription(key):
            return "/\(key)/subscription"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .fetchRecommendPlaylist, .fetchPlaylistDetail, .fetchPlaylistSongs, .checkSubscription:
            return .get

        case .createPlaylist, .addSongIntoPlaylist:
            return .post

        case let .subscribePlaylist(_, isSubscribing):
            return isSubscribing ? .delete : .post

        case .removeSongs:
            return .delete

        case .updatePlaylist, .updateTitleAndPrivate, .uploadImage:
            return .patch
        }
    }

    public var task: Moya.Task {
        switch self {
        case .fetchRecommendPlaylist, .fetchPlaylistDetail, .fetchPlaylistSongs, .subscribePlaylist, .checkSubscription:
            return .requestPlain

        case let .updateTitleAndPrivate(_, title: title, isPrivate: isPrivate):
            return .requestJSONEncodable(TitleAndPrivateRequsetDTO(title: title, private: isPrivate))

        case let .createPlaylist(title: title):
            return .requestJSONEncodable(CreatePlaylistRequsetDTO(title: title))

        case let .addSongIntoPlaylist(_, songs: songs):
            return .requestJSONEncodable(AddSongRequestDTO(songIds: songs))

        case let .updatePlaylist(_, songs: songs):
            return .requestJSONEncodable(SongsKeyRequestDTO(songIds: songs))

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
        case .fetchRecommendPlaylist, .fetchPlaylistSongs:
            return .none

        case let .fetchPlaylistDetail(_, type):

            return type == .my ? .accessToken : .none

        case .createPlaylist, .updatePlaylist, .addSongIntoPlaylist,
             .removeSongs, .updateTitleAndPrivate, .uploadImage, .subscribePlaylist, .checkSubscription:
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
