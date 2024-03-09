//
//  AppRepositoryImpl.swift
//  AppDomain
//
//  Created by KTH on 2024/03/04.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import AppDomainInterface
import Foundation
import RxSwift

public final class AppRepositoryImpl: AppRepository {
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
