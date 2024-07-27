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
    case uploadDefaultImage(key: String, imageName: String) // 플레이리스트 default 이미지 업로드
    case requestCustomImageURL(key: String, imageSize: Int) // 커스텀 이미지를 저장할 presigned url 받아오기
    case subscribePlaylist(key: String, isSubscribing: Bool) // 플레이리스트 구독하기 / 구독 취소하기
    case checkSubscription(key: String)
    case fetchRecommendPlaylist // 추천 플리 불러오기
    case uploadCustomImage(url: String, data: Data)
}

extension PlaylistAPI: WMAPI {
    public var baseURL: URL {
        switch self {
        case let .uploadCustomImage(url, _):
            return URL(string: url)!

        default:
            return URL(string: BASE_URL())!
        }
    }

    public var domain: WMDomain {
        switch self {
        case .uploadCustomImage:
            return .empty

        default:
            return .playlist
        }
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

        case let .uploadDefaultImage(key: key, _):
            return "/\(key)/image"

        case let .requestCustomImageURL(key, _):
            return "/\(key)/image/upload"

        case let .subscribePlaylist(key, _), let .checkSubscription(key):
            return "/\(key)/subscription"

        case .uploadCustomImage:
            return ""
        }
    }

    public var method: Moya.Method {
        switch self {
        case .fetchRecommendPlaylist, .fetchPlaylistDetail, .fetchPlaylistSongs, .checkSubscription:
            return .get

        case .createPlaylist, .addSongIntoPlaylist, .requestCustomImageURL:
            return .post

        case let .subscribePlaylist(_, isSubscribing):
            return isSubscribing ? .delete : .post

        case .removeSongs:
            return .delete

        case .uploadCustomImage:
            return .put

        case .updatePlaylist, .updateTitleAndPrivate, .uploadDefaultImage:
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

        case let .uploadDefaultImage(_, imageName):
            return .requestJSONEncodable(DefaultImageRequestDTO(imageName: imageName))

        case let .requestCustomImageURL(key, imageSize):
            return .requestParameters(
                parameters: ["key": key, "contentLength": imageSize],
                encoding: URLEncoding.queryString
            )

        case let .uploadCustomImage(_, data: data):
            return .requestData(data)
        }
    }

    public var headers: [String: String]? {
        switch self {
        case let .uploadCustomImage(_, data: data):
            return ["Content-Type": "image/jpeg", " Contnet-Length": "\(data.count)"]
        default:
            return ["Content-Type": "application/json"]
        }
    }

    public var jwtTokenType: JwtTokenType {
        switch self {
        case .fetchRecommendPlaylist, .fetchPlaylistSongs, .uploadCustomImage:
            return .none

        case let .fetchPlaylistDetail(_, type):
            return type == .my ? .accessToken : .none

        case .createPlaylist, .updatePlaylist, .addSongIntoPlaylist, .requestCustomImageURL,
             .removeSongs, .updateTitleAndPrivate, .uploadDefaultImage, .subscribePlaylist, .checkSubscription:
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
