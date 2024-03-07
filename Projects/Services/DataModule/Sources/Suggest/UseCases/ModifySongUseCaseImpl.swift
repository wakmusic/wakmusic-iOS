//
//  ModifySongUseCaseImpl.swift
//  DataModuleTests
//
//  Created by KTH on 2023/04/14.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DataMappingModule
import DomainModule
import ErrorModule
import Foundation
import RxSwift

public struct ModifySongUseCaseImpl: ModifySongUseCase {
    private let suggestRepository: any SuggestRepository

    public init(
        suggestRepository: SuggestRepository
    ) {
        self.suggestRepository = suggestRepository
    }

    public func execute(
        type: SuggestSongModifyType,
        userID: String,
        artist: String,
        songTitle: String,
        youtubeLink: String,
        content: String
    ) -> Single<ModifySongEntity> {
        suggestRepository.modifySong(
            type: type,
            userID: userID,
            artist: artist,
            songTitle: songTitle,
            youtubeLink: youtubeLink,
            content: content
        )
    }
}
