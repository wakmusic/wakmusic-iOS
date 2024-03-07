//
//  FetchArtistListUseCaseImpl.swift
//  DataModule
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import ArtistDomainInterface

public struct FetchArtistListUseCaseImpl: FetchArtistListUseCase {
    private let artistRepository: any ArtistRepository

    public init(
        artistRepository: ArtistRepository
    ) {
        self.artistRepository = artistRepository
    }

    public func execute() -> Single<[ArtistListEntity]> {
        artistRepository.fetchArtistList()
    }
}
