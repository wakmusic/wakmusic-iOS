import BaseDomain
import BaseDomainInterface
import Foundation
import PlaylistDomainInterface
import RxSwift
import SongsDomain
import SongsDomainInterface

public final class RemotePlaylistDataSourceImpl: BaseRemoteDataSource<PlaylistAPI>, RemotePlaylistDataSource {
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

    public func updateTitleAndPrivate(key: String, title: String?, isPrivate: Bool?) -> Completable {
        request(.updateTitleAndPrivate(key: key, title: title, isPrivate: isPrivate))
            .asCompletable()
    }

    public func createPlaylist(title: String) -> Single<PlaylistBaseEntity> {
        request(.createPlaylist(title: title))
            .map(PlayListBaseResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func fetchPlaylistSongs(id: String) -> Single<[SongEntity]> {
        request(.fetchPlaylistSongs(key: id))
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

    public func uploadImage(key: String, model: UploadImageType) -> Single<BaseImageEntity> {
        request(.uploadImage(key: key, model: model))
            .map(BaseImageResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func subscribePlaylist(key: String, isSubscribing: Bool) -> Completable {
        request(.subscribePlaylist(key: key, isSubscribing: isSubscribing))
            .asCompletable()
    }

    public func checkSubscriptionUseCase(key: String) -> Single<Bool> {
        request(.checkSubscription(key: key))
            .map(CheckSubscriptionResponseDTO.self)
            .map { $0.data }
    }
}
