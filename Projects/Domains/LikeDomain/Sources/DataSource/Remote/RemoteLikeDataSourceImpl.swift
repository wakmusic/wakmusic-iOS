import BaseDomain
import Foundation
import LikeDomainInterface
import RxSwift

public final class RemoteLikeDataSourceImpl: BaseRemoteDataSource<LikeAPI>, RemoteLikeDataSource {
    public func addLikeSong(id: String) -> Single<LikeEntity> {
        request(.addLikeSong(id: id))
            .map(LikeResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func cancelLikeSong(id: String) -> Single<LikeEntity> {
        request(.cancelLikeSong(id: id))
            .map(LikeResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func checkIsLikedSong(id: String) -> Single<Bool> {
        request(.checkIsLikedSong(id: id))
            .map(CheckIsLikedResponseDTO.self)
            .map(\.isLiked)
    }
}
