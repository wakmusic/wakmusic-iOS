//
//  FetchArtistListUseCaseImpl.swift
//  DataModule
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import LikeDomainInterface
import RxSwift

public struct CancelLikeSongUseCaseImpl: CancelLikeSongUseCase {
    private let likeRepository: any LikeRepository

    public init(
        likeRepository: LikeRepository
    ) {
        self.likeRepository = likeRepository
    }

    public func execute(id: String) -> Single<LikeEntity> {
        likeRepository.cancelLikeSong(id: id)
    }
}
