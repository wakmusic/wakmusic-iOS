//
//  FetchAppCheckUseCase.swift
//  AppDomain
//
//  Created by KTH on 2024/03/04.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift

public protocol FetchAppCheckUseCase: Sendable {
    func execute() -> Single<AppCheckEntity>
}
