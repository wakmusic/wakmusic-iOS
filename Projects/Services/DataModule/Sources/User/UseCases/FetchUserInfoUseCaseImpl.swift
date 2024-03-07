//
//  FetchUserInfoUseCaseImpl.swift
//  DataModule
//
//  Created by yongbeomkwak on 12/8/23.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DataMappingModule
import DomainModule
import ErrorModule
import Foundation
import RxSwift

public struct FetchUserInfoUseCaseImpl: FetchUserInfoUseCase {
    private let userRepository: any UserRepository

    public init(
        userRepository: UserRepository
    ) {
        self.userRepository = userRepository
    }

    public func execute() -> Single<UserInfoEntity> {
        userRepository.fetchUserInfo()
    }
}
