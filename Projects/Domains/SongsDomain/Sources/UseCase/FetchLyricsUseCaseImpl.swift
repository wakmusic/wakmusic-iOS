//
//  FetchLyricsUseCaseImpl.swift
//  DataModule
//
//  Created by YoungK on 2023/02/22.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import RxSwift
import SongsDomainInterface

public struct FetchLyricsUseCaseImpl: FetchLyricsUseCase {
    private let songsRepository: any SongsRepository

    public init(
        songsRepository: SongsRepository
    ) {
        self.songsRepository = songsRepository
    }

    public func execute(id: String) -> Single<LyricsEntity> {
        songsRepository.fetchLyrics(id: id)
    }
}
