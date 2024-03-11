//
//  FetchArtistListUseCaseImpl.swift
//  DataModule
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import UserDomainInterface

public struct FetchFavoriteSongsUseCaseImpl: FetchFavoriteSongsUseCase {
    private let userRepository: any UserRepository

    public init(
        userRepository: UserRepository
    ) {
        self.userRepository = userRepository
    }

    public func execute() -> Single<[FavoriteSongEntity]> {
        userRepository.fetchFavoriteSongs()
    }
}
