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

public struct AddLikeSongUseCaseImpl: AddLikeSongUseCase {
   
    

    private let likeRepository: any LikeRepository

    public init(
        likeRepository: LikeRepository
    ) {
        self.likeRepository = likeRepository
    }
    
    public func execute(id: String) -> Single<BaseEntity> {
        likeRepository.addLikeSong(id: id)
    }

}
