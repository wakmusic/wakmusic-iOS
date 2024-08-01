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

    public init(remoteLikeDataSource: any RemoteLikeDataSource) {
        self.remoteLikeDataSource = remoteLikeDataSource
    }

    public func addLikeSong(id: String) -> Single<LikeEntity> {
        remoteLikeDataSource.addLikeSong(id: id)
    }

    public func cancelLikeSong(id: String) -> Single<LikeEntity> {
        remoteLikeDataSource.cancelLikeSong(id: id)
    }

    public func checkIsLikedSong(id: String) -> Single<Bool> {
        remoteLikeDataSource.checkIsLikedSong(id: id)
    }
}
