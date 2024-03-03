//
//  RemoteAppDataSourceImpl.swift
//  AppDomain
//
//  Created by KTH on 2024/03/04.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import Foundation
import BaseDomain
import AppDomainInterface
import RxSwift

public final class RemoteAppDataSourceImpl: BaseRemoteDataSource<AppAPI>, RemoteAppDataSource {
    public func fetchAppCheck() -> Single<AppCheckEntity> {
        request(.fetchAppCheck)
            .map(FetchAppCheckResponseDTO.self)
            .map({$0.toDomain()})
    }
}
