//
//  ArtistRepositoryImpl.swift
//  DataModule
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import ErrorModule
import LikeDomainInterface
import RxSwift

public final class LikeRepositoryImpl: LikeRepository {
    private let remoteLikeDataSource: any RemoteLikeDataSource
    private let localLikeDataSource: any LocalLikeDataSource

    public init(
        remoteLikeDataSource: any RemoteLikeDataSource,
        localLikeDataSource: any LocalLikeDataSource
    ) {
        self.remoteLikeDataSource = remoteLikeDataSource
        self.localLikeDataSource = localLikeDataSource
    }

    public func addLikeSong(id: String) -> Single<LikeEntity> {
        localLikeDataSource.addLikeSong(id: id)
            .andThen(remoteLikeDataSource.addLikeSong(id: id))
    }

    public func cancelLikeSong(id: String) -> Single<LikeEntity> {
        localLikeDataSource.cancelLikeSong(id: id)
            .andThen(remoteLikeDataSource.cancelLikeSong(id: id))
    }

    public func checkIsLikedSong(id: String) -> Single<Bool> {
        localLikeDataSource.checkIsLikedSong(id: id)
    }
}
