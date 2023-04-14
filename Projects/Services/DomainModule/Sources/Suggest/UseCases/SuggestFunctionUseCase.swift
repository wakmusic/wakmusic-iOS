//
//  SuggestFunctionUseCase.swift
//  DomainModule
//
//  Created by KTH on 2023/04/14.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import DataMappingModule

public protocol SuggestFunctionUseCase {
    func execute(type: SuggestPlatformType, userID: String, content: String) -> Single<SuggestFunctionEntity>
}
