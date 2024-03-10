//
//  FetchArtistListUseCaseImpl.swift
//  DataModule
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import PlayListDomainInterface
import Foundation
import RxSwift
import BaseDomainInterface

public struct RemoveSongsUseCaseImpl: RemoveSongsUseCase {
    private let playListRepository: any PlayListRepository

    public init(
        playListRepository: PlayListRepository
    ) {
        self.playListRepository = playListRepository
    }

    public func execute(key: String, songs: [String]) -> Single<BaseEntity> {
        return playListRepository.removeSongs(key: key, songs: songs)
    }
}
