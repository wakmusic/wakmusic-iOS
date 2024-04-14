//
//  ArtistRepositoryImpl.swift
//  DataModule
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import AuthDomainInterface
import RxSwift

public final class AuthRepositoryImpl: AuthRepository {
    private let localAuthDataSource: any LocalAuthDataSource
    private let remoteAuthDataSource: any RemoteAuthDataSource

    public init(
        localAuthDataSource: any LocalAuthDataSource,
        remoteAuthDataSource: any RemoteAuthDataSource
    ) {
        self.localAuthDataSource = localAuthDataSource
        self.remoteAuthDataSource = remoteAuthDataSource
    }

    public func fetchToken(token: String, type: ProviderType) -> Single<AuthLoginEntity> {
        remoteAuthDataSource.fetchToken(token: token, type: type)
    }

    public func fetchNaverUserInfo(tokenType: String, accessToken: String) -> Single<NaverUserInfoEntity> {
        remoteAuthDataSource.fetchNaverUserInfo(tokenType: tokenType, accessToken: accessToken)
    }

    public func logout() -> Completable {
        Completable.create { [localAuthDataSource] observer in
            localAuthDataSource.logout()
            observer(.completed)
            return Disposables.create()
        }
    }
}
