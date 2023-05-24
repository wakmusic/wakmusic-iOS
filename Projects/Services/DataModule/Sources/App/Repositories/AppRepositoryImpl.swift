//
//  AppRepositoryImpl.swift
//  DataModule
//
//  Created by yongbeomkwak on 2023/05/23.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DataMappingModule
import DomainModule
import ErrorModule
import NetworkModule
import DatabaseModule
import RxSwift

public struct AppRepositoryImpl :AppRepository {
    private let remoteAppDataSource: any RemoteAppDataSource
    
    public init(
        remoteAppDataSource: RemoteAppDataSource
    ) {
        self.remoteAppDataSource = remoteAppDataSource
    }
    
    public func fetchCheckApp() -> Single<AppInfoEntity> {
        remoteAppDataSource.fetchCheckApp()
    }
    
    
}
