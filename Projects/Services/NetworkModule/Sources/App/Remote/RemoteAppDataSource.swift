//
//  RemoteAppDataSource.swift
//  NetworkModuleTests
//
//  Created by yongbeomkwak on 2023/05/23.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import DataMappingModule
import ErrorModule
import DomainModule
import RxSwift

public protocol RemoteAppDataSource {
    func fetchCheckApp() -> Single<AppInfoEntity>
}
