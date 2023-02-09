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

public struct FetchRecommendPlayListUseCaseImpl: FetchRecommendPlaylistsUseCase {
   
    

    private let playListRepository: any PlayListRepository

    public init(
        playListRepository: PlayListRepository
    ) {
        self.playListRepository = playListRepository
    }
    
    public func execute() -> Single<[DomainModule.RecommendPlayListEntity]> {
        playListRepository.fetchRecommendPlayLists()
    }

   
}
