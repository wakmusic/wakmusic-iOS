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

public struct FetchRecommendPlaylistUseCaseImpl: FetchRecommendPlaylistUseCase {
    private let playlistRepository: any PlaylistRepository

    public init(
        playlistRepository: PlaylistRepository
    ) {
        self.playlistRepository = playlistRepository
    }

    public func execute() -> Single<[RecommendPlaylistEntity]> {
        playlistRepository.fetchRecommendPlaylist()
    }
}
