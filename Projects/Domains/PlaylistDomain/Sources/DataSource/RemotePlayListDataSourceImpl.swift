import BaseDomain
import BaseDomainInterface
import Foundation
import PlaylistDomainInterface
import RxSwift
import SongsDomain
import SongsDomainInterface

public final class RemotePlayListDataSourceImpl: BaseRemoteDataSource<PlayListAPI>, RemotePlayListDataSource {
    public func fetchRecommendPlayList() -> Single<[RecommendPlayListEntity]> {
        request(.fetchRecommendPlayList)
            .map([SingleRecommendPlayListResponseDTO].self)
            .map { $0.map { $0.toDomain() }}
    }

    public func fetchPlayListDetail(id: String, type: PlaylistType) -> Single<PlayListDetailEntity> {
        request(.fetchPlayListDetail(id: id, type: type))
            .map(SinglePlayListDetailResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func updateTitleAndPrivate(key: String, title: String?, isPrivate: Bool?) -> Completable {
        request(.updateTitleAndPrivate(key: key, title: title, isPrivate: isPrivate))
            .asCompletable()
    }

    public func createPlayList(title: String) -> Single<PlayListBaseEntity> {
        request(.createPlayList(title: title))
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

    public func addSongIntoPlayList(key: String, songs: [String]) -> Single<AddSongEntity> {
        request(.addSongIntoPlayList(key: key, songs: songs))
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
}
