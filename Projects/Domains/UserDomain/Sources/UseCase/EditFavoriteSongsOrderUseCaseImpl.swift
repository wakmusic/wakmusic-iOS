//
//  FetchArtistListUseCaseImpl.swift
//  DataModule
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UserDomainInterface
import Foundation
import RxSwift
import BaseDomainInterface

public struct EditFavoriteSongsOrderUseCaseImpl: EditFavoriteSongsOrderUseCase {
    private let userRepository: any UserRepository

    public init(
        userRepository: UserRepository
    ) {
        self.userRepository = userRepository
    }

    public func execute(ids: [String]) -> Single<BaseEntity> {
        userRepository.editFavoriteSongsOrder(ids: ids)
    }
}
