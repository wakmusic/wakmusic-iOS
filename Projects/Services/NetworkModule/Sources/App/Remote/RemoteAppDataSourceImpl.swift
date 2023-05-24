//
//  RemoteAppDataSourceImpl.swift
//  NetworkModuleTests
//
//  Created by yongbeomkwak on 2023/05/23.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import APIKit
import RxSwift
import DataMappingModule
import DomainModule
import ErrorModule
import Foundation

public final class RemoteAppDataSourceImpl: BaseRemoteDataSource<AppAPI>, RemoteAppDataSource {
    public func fetchCheckApp() -> Single<AppInfoEntity> {
        request(.checkVersion)
            .map(AppInfoDTO.self)
            .map({$0.toDomain()})
    }
}
