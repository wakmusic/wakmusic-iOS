//
//  PostPlaybackLogUseCaseImpl.swift
//  DataModule
//
//  Created by KTH on 2023/08/27.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import RxSwift
import DataMappingModule
import DomainModule
import ErrorModule
import Foundation

public struct PostPlaybackLogUseCaseImpl: PostPlaybackLogUseCase {    
    private let playRepository: any PlayRepository

    public init(
        playRepository: PlayRepository
    ) {
        self.playRepository = playRepository
    }
    
    public func execute(item: Data) -> Single<PostPlaybackLogEntity> {
        playRepository.postPlaybackLog(item: item)
    }
}
