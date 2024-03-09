//
//  PostPlaybackLogUseCaseImpl.swift
//  DataModule
//
//  Created by KTH on 2023/08/27.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DataMappingModule
import DomainModule
import ErrorModule
import Foundation
import RxSwift

public struct PostPlaybackLogUseCaseImpl: PostPlaybackLogUseCase {
    private let playRepository: any PlayRepository

    public init(
        playRepository: PlayRepository
    ) {
        self.playRepository = playRepository
    }

    public func execute(item: Data) -> Single<PlaybackLogEntity> {
        playRepository.postPlaybackLog(item: item)
    }
}
