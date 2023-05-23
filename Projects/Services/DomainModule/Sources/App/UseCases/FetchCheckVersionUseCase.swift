//
//  FetchCheckVersionUseCase.swift
//  DomainModuleTests
//
//  Created by yongbeomkwak on 2023/05/23.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import DataMappingModule

public protocol FetchCheckVersionUseCase {
    func execute() -> Single<VersionCheckEntity>
}
