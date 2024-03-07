//
//  AppComponent+Search.swift
//  WaktaverseMusic
//
//  Created by yongbeomkwak on 2023/02/07.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DomainModule
import DataModule
import NetworkModule
import AppDomain
import AppDomainInterface

// MARK: 변수명 주의
// AppComponent 내 변수 == Dependency 내 변수 이름 같아야함

public extension AppComponent {
    var remoteAppDataSource: any RemoteAppDataSource {
        shared {
            RemoteAppDataSourceImpl(keychain: keychain)
        }
    }
    var appRepository: any AppRepository {
        shared {
            AppRepositoryImpl(remoteAppDataSource: remoteAppDataSource)
        }
    }
    var fetchAppCheckUseCase: any FetchAppCheckUseCase {
        shared {
            FetchAppCheckUseCaseImpl(appRepository: appRepository)
        }
    }
}
