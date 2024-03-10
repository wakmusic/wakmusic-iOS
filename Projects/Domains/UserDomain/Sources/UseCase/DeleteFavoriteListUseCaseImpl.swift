//
//  DeleteLikeListUseCaseImpl.swift
//  DataModule
//
//  Created by KTH on 2023/04/03.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UserDomainInterface
import Foundation
import RxSwift
import BaseDomainInterface

public struct DeleteFavoriteListUseCaseImpl: DeleteFavoriteListUseCase {
    private let userRepository: any UserRepository

    public init(
        userRepository: UserRepository
    ) {
        self.userRepository = userRepository
    }

    public func execute(ids: [String]) -> Single<BaseEntity> {
        userRepository.deleteFavoriteList(ids: ids)
    }
}
