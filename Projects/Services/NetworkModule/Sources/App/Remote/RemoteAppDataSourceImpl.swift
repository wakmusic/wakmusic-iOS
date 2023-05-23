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
import NetworkModule

public final class RemoteAppDataSourceImpl: BaseRemoteDataSource<AppAPI>, RemoteAppDataSource {
    public func checkVersion() -> Single<VersionCheckEntity> {
        request(.checkVersion)
            .map(CheckVersionResponseDTO.self)
            .map({$0.toDomain()})
    }
    
    
}
