//
//  SuggestFunctionUseCaseImpl.swift
//  DataModuleTests
//
//  Created by KTH on 2023/04/14.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import DataMappingModule
import DomainModule
import ErrorModule

public struct SuggestFunctionUseCaseImpl: SuggestFunctionUseCase {
    private let suggestRepository: any SuggestRepository

    public init(
        suggestRepository: SuggestRepository
    ) {
        self.suggestRepository = suggestRepository
    }
    public func execute(type: SuggestPlatformType, userID: String, content: String) -> Single<SuggestFunctionEntity> {
        suggestRepository.suggestFunction(type: type, userID: userID, content: content)
    }
}
