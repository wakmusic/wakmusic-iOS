//
//  FetchArtistListUseCaseImpl.swift
//  DataModule
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import PlaylistDomainInterface
import RxSwift

public struct AddSongIntoPlayListUseCaseImpl: AddSongIntoPlayListUseCase {
    private let playListRepository: any PlayListRepository

    public init(
        playListRepository: PlayListRepository
    ) {
        self.playListRepository = playListRepository
    }

    public func execute(key: String, songs: [String]) -> Single<AddSongEntity> {
        playListRepository.addSongIntoPlayList(key: key, songs: songs)
    }
}
