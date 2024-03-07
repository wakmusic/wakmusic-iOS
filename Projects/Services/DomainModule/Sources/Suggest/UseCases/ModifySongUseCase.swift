//
//  ModifySongUseCase.swift
//  DomainModule
//
//  Created by KTH on 2023/04/14.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DataMappingModule
import Foundation
import RxSwift

public protocol ModifySongUseCase {
    func execute(
        type: SuggestSongModifyType,
        userID: String,
        artist: String,
        songTitle: String,
        youtubeLink: String,
        content: String
    ) -> Single<ModifySongEntity>
}
