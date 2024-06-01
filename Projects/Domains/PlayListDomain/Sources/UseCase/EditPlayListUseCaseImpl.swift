//
//  FetchArtistListUseCaseImpl.swift
//  DataModule
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import BaseDomainInterface
import Foundation
import PlayListDomainInterface
import RxSwift

public struct EditPlayListUseCaseImpl: UpdatePlaylist {
    private let playListRepository: any PlayListRepository

    public init(
        playListRepository: PlayListRepository
    ) {
        self.playListRepository = playListRepository
    }

    public func execute(key: String, songs: [String]) -> Single<BaseEntity> {
        return playListRepository.updatePlayList(key: key, songs: songs)
    }
}
