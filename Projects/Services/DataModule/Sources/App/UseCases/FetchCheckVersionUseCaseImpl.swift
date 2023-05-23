//
//  FetchCheckVersionUseCaseImpl.swift
//  DataModule
//
//  Created by yongbeomkwak on 2023/05/23.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import DataMappingModule
import DomainModule
import ErrorModule

public struct FetchCheckVersionUseCaseImpl: FetchCheckVersionUseCase {
    
    private let appRepository: any AppRepository

    public init(
        appRepository: AppRepository
    ) {
        self.appRepository = appRepository
    }
    
    public func execute() -> Single<VersionCheckEntity> {
        appRepository.checkVersion()
    }
    
    
}
