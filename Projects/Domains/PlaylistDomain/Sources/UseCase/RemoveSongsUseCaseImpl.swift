//
//  FetchArtistListUseCaseImpl.swift
//  DataModule
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import BaseDomainInterface
import Foundation
import PlaylistDomainInterface
import RxSwift

public struct RemoveSongsUseCaseImpl: RemoveSongsUseCase {
    private let playlistRepository: any PlaylistRepository

    public init(
        playlistRepository: PlaylistRepository
    ) {
        self.playlistRepository = playlistRepository
    }

    public func execute(key: String, songs: [String]) -> Completable {
        return playlistRepository.removeSongs(key: key, songs: songs)
    }
}
