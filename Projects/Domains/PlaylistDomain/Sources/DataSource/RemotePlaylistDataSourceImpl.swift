import BaseDomain
import BaseDomainInterface
import Foundation
import Moya
import PlaylistDomainInterface
import RxSwift
import SongsDomain
import SongsDomainInterface

public final class RemotePlaylistDataSourceImpl: BaseRemoteDataSource<PlaylistAPI>, RemotePlaylistDataSource {
    private let provider = MoyaProvider<CustomPlaylistImageAPI>()

    public func fetchRecommendPlaylist() -> Single<[RecommendPlaylistEntity]> {
        request(.fetchRecommendPlaylist)
            .map([SingleRecommendPlayListResponseDTO].self)
            .map { $0.map { $0.toDomain() }}
    }

    public func fetchPlaylistDetail(id: String, type: PlaylistType) -> Single<PlaylistDetailEntity> {
        request(.fetchPlaylistDetail(id: id, type: type))
            .map(SinglePlayListDetailResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func fetchWMPlaylistDetail(id: String) -> Single<WMPlaylistDetailEntity> {
        request(.fetchWMPlaylistDetail(id: id))
            .map(WMPlaylistDetailResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func updateTitleAndPrivate(key: String, title: String?, isPrivate: Bool?) -> Completable {
        request(.updateTitleAndPrivate(key: key, title: title, isPrivate: isPrivate))
            .asCompletable()
    }

    public func createPlaylist(title: String) -> Single<PlaylistBaseEntity> {
        request(.createPlaylist(title: title))
            .map(PlayListBaseResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func fetchPlaylistSongs(key: String) -> Single<[SongEntity]> {
        request(.fetchPlaylistSongs(key: key))
            .map([SingleSongResponseDTO].self)
            .map { $0.map { $0.toDomain() } }
    }

    public func updatePlaylist(key: String, songs: [String]) -> Completable {
        request(.updatePlaylist(key: key, songs: songs))
            .asCompletable()
    }

    public func addSongIntoPlaylist(key: String, songs: [String]) -> Single<AddSongEntity> {
        request(.addSongIntoPlaylist(key: key, songs: songs))
            .map(AddSongResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func removeSongs(key: String, songs: [String]) -> Completable {
        request(.removeSongs(key: key, songs: songs))
            .asCompletable()
    }

    public func uploadDefaultImage(key: String, model: String) -> Completable {
        request(.uploadDefaultImage(key: key, imageName: model))
            .asCompletable()
    }

    public func subscribePlaylist(key: String, isSubscribing: Bool) -> Completable {
        request(.subscribePlaylist(key: key, isSubscribing: isSubscribing))
            .asCompletable()
    }

    public func checkSubscription(key: String) -> Single<Bool> {
        request(.checkSubscription(key: key))
            .map(CheckSubscriptionResponseDTO.self)
            .map { $0.data }
    }

    public func requestCustomImageURL(key: String, imageSize: Int) -> Single<CustomImageURLEntity> {
        request(.requestCustomImageURL(key: key, imageSize: imageSize))
            .map(CustomImageURLResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func uploadCustomImage(presignedURL: String, data: Data) -> Completable {
        return provider.rx
            .request(CustomPlaylistImageAPI.uploadCustomImage(url: presignedURL, data: data))
            .asCompletable()
    }

    public func requestPlaylistOwnerID(key: String) -> Single<PlaylistOwnerIDEntity> {
        return request(.requestPlaylistOwnerID(key: key))
            .map(PlaylistOwnerIDResponseDTO.self)
            .map { $0.toDomain() }
    }
}
