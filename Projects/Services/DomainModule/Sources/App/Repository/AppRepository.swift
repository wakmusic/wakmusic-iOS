//
//  AppRepository.swift
//  DomainModuleTests
//
//  Created by yongbeomkwak on 2023/05/23.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import DataMappingModule
import ErrorModule


public protocol AppRepository {
    func fetchCheckApp() -> Single<AppInfoEntity>
   
}
