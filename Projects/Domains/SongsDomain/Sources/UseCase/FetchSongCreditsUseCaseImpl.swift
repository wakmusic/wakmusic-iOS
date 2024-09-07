//
//  FetchSongCreditsUseCaseImpl.swift
//  SongsDomain
//
//  Created by KTH on 5/14/24.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import RxSwift
import SongsDomainInterface

public struct FetchSongCreditsUseCaseImpl: FetchSongCreditsUseCase {
    private let songsRepository: any SongsRepository

    public init(
        songsRepository: SongsRepository
    ) {
        self.songsRepository = songsRepository
    }

    public func execute(id: String) -> Single<[SongCreditsEntity]> {
        songsRepository.fetchSongCredits(id: id)
    }
}
