//
//  FetchArtistListUseCaseImpl.swift
//  DataModule
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import LikeDomainInterface
import Foundation
import RxSwift

public struct FetchLikeNumOfSongUseCaseImpl: FetchLikeNumOfSongUseCase {
    private let likeRepository: any LikeRepository

    public init(
        likeRepository: LikeRepository
    ) {
        self.likeRepository = likeRepository
    }

    public func execute(id: String) -> Single<LikeEntity> {
        likeRepository.fetchLikeNumOfSong(id: id)
    }
}
