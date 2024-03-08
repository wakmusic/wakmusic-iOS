//
//  FetchArtistSongListUseCaseImpl.swift
//  DataModule
//
//  Created by KTH on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import ArtistDomainInterface

public struct FetchArtistSongListUseCaseImpl: FetchArtistSongListUseCase {
    private let artistRepository: any ArtistRepository

    public init(
        artistRepository: ArtistRepository
    ) {
        self.artistRepository = artistRepository
    }

    public func execute(id: String, sort: ArtistSongSortType, page: Int) -> Single<[ArtistSongListEntity]> {
        artistRepository.fetchArtistSongList(id: id, sort: sort, page: page)
    }
}
