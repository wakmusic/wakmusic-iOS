//
//  FetchCheckAppUseCaseImpl.swift
//  AppDomain
//
//  Created by KTH on 2024/03/04.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import AppDomainInterface
import Foundation
import RxSwift

public struct FetchAppCheckUseCaseImpl: FetchAppCheckUseCase {
    private let appRepository: any AppRepository

    public init(
        appRepository: AppRepository
    ) {
        self.appRepository = appRepository
    }

    public func execute() -> Single<AppCheckEntity> {
        appRepository.fetchAppCheck()
    }
}
