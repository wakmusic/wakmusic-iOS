//
//  AppRepositoryImpl.swift
//  AppDomain
//
//  Created by KTH on 2024/03/04.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import Foundation
import AppDomainInterface
import RxSwift

public struct AppRepositoryImpl: AppRepository {
    private let remoteAppDataSource: any RemoteAppDataSource

    public init(
        remoteAppDataSource: RemoteAppDataSource
    ) {
        self.remoteAppDataSource = remoteAppDataSource
    }

    public func fetchAppCheck() -> Single<AppCheckEntity> {
        remoteAppDataSource.fetchAppCheck()
    }
}
