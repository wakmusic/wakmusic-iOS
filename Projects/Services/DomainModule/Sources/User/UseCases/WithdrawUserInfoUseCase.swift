//
//  WithdrawUserInfoUseCase.swift
//  DomainModule
//
//  Created by yongbeomkwak on 12/8/23.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import DataMappingModule

public protocol WithdrawUserInfoUseCase {
    func execute() -> Single<BaseEntity>
}
