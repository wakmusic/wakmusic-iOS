//
//  ArtistRepositoryImpl.swift
//  DataModule
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import AuthDomainInterface
import BaseDomainInterface
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

    public func fetchToken(providerType: ProviderType, token: String) -> Single<AuthLoginEntity> {
        remoteAuthDataSource.fetchToken(providerType: providerType, token: token)
    }

    public func reGenerateAccessToken() -> Single<AuthLoginEntity> {
        remoteAuthDataSource.reGenerateAccessToken()
    }

    public func logout(localOnly: Bool) -> Completable {
        let localLogoutCompletable = Completable.create { [localAuthDataSource] observer in
            localAuthDataSource.logout()
            observer(.completed)
            return Disposables.create()
        }

        if localOnly {
            return localLogoutCompletable

        } else {
            return remoteAuthDataSource.logout()
                .andThen(localLogoutCompletable)
        }
    }

    public func checkIsExistAccessToken() -> Single<Bool> {
        let isExistAccessToken = localAuthDataSource.checkIsExistAccessToken()
        return .just(isExistAccessToken)
    }
}
