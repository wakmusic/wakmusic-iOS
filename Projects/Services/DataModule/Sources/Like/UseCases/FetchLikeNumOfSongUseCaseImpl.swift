//
//  FetchArtistListUseCaseImpl.swift
//  DataModule
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import DataMappingModule
import DomainModule
import ErrorModule

public struct FetchLikeNumOfSongUseCaseImpl: FetchLikeNumOfSongUseCase {
   
    

    private let likeRepository: any LikeRepository

    public init(
        likeRepository: LikeRepository
    ) {
        self.likeRepository = likeRepository
    }
    
    public func execute(id: String) -> Single<FavoriteSongEntity> {
        likeRepository.fetchLikeNumOfSong(id: id)
    }

}
