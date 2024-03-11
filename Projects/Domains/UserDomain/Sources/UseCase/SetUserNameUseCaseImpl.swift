//
//  FetchArtistListUseCaseImpl.swift
//  DataModule
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import BaseDomainInterface
import Foundation
import RxSwift
import UserDomainInterface

public struct SetUserNameUseCaseImpl: SetUserNameUseCase {
    private let userRepository: any UserRepository

    public init(
        userRepository: UserRepository
    ) {
        self.userRepository = userRepository
    }

    public func execute(name: String) -> Single<BaseEntity> {
        userRepository.setUserName(name: name)
    }
}
