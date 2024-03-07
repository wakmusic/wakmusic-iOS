import APIKit
import DataMappingModule
import DomainModule
import ErrorModule
import Foundation
import RxSwift

public final class RemotePlayListDataSourceImpl: BaseRemoteDataSource<PlayListAPI>, RemotePlayListDataSource {
    public func fetchRecommendPlayList() -> Single<[RecommendPlayListEntity]> {
        request(.fetchRecommendPlayList)
            .map([SingleRecommendPlayListResponseDTO].self)
            .map { $0.map { $0.toDomain() }}
    }

    public func fetchPlayListDetail(id: String, type: PlayListType) -> Single<PlayListDetailEntity> {
        request(.fetchPlayListDetail(id: id, type: type))
            .map(SinglePlayListDetailResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func createPlayList(title: String) -> Single<PlayListBaseEntity> {
        request(.createPlayList(title: title))
            .map(PlayListBaseResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func editPlayList(key: String, songs: [String]) -> Single<BaseEntity> {
        request(.editPlayList(key: key, songs: songs))
            .map(BaseResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func editPlayListName(key: String, title: String) -> Single<EditPlayListNameEntity> {
        request(.editPlayListName(key: key, title: title))
            .map(EditPlayListNameResponseDTO.self)
            .map { $0.toDomain(title: title) }
    }

    public func deletePlayList(key: String) -> Single<BaseEntity> {
        request(.deletePlayList(key: key))
            .map(BaseResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func loadPlayList(key: String) -> Single<PlayListBaseEntity> {
        request(.loadPlayList(key: key))
            .map(PlayListBaseResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func addSongIntoPlayList(key: String, songs: [String]) -> Single<AddSongEntity> {
        request(.addSongIntoPlayList(key: key, songs: songs))
            .map(AddSongResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func removeSongs(key: String, songs: [String]) -> Single<BaseEntity> {
        request(.removeSongs(key: key, songs: songs))
            .map(BaseResponseDTO.self)
            .map { $0.toDomain() }
    }
}
