//
//  BaseRemoteDataSource.swift
//  BaseDomain
//
//  Created by KTH on 2024/03/04.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import Foundation
import KeychainModule
@preconcurrency import Moya
@preconcurrency import RxMoya
import RxSwift

open class BaseRemoteDataSource<API: WMAPI>: @unchecked Sendable {
    private let keychain: any Keychain
    private let provider: MoyaProvider<API>
    private let refreshProvider: MoyaProvider<TokenRefreshAPI>
    private let decoder = JSONDecoder()
    private let maxRetryCount = 2

    public init(
        keychain: any Keychain,
        provider: MoyaProvider<API>? = nil
    ) {
        self.keychain = keychain

        #if DEBUG || QA
            self.provider = provider ?? MoyaProvider(plugins: [
                JwtPlugin(keychain: keychain),
                BasePlugin(keychain: keychain),
                CustomLoggingPlugin()
            ])
            self.refreshProvider = MoyaProvider(plugins: [
                JwtPlugin(keychain: keychain),
                CustomLoggingPlugin()
            ])
        #else
            self.provider = provider ?? MoyaProvider(plugins: [
                JwtPlugin(keychain: keychain),
                BasePlugin(keychain: keychain)
            ])
            self.refreshProvider = MoyaProvider(plugins: [JwtPlugin(keychain: keychain)])
        #endif

    }

    public func request(_ api: API) -> Single<Response> {
        return Single<Response>.create { single in
            var disposabels = [Disposable]()
            if self.checkIsApiNeedsAuthorization(api) {
                disposabels.append(
                    self.authorizedRequest(api).subscribe(
                        onSuccess: { single(.success($0)) },
                        onFailure: { single(.failure($0)) }
                    )
                )
            } else {
                disposabels.append(
                    self.defaultRequest(api).subscribe(
                        onSuccess: { single(.success($0)) },
                        onFailure: { single(.failure($0)) }
                    )
                )
            }
            return Disposables.create(disposabels)
        }
    }
}

private extension BaseRemoteDataSource {
    func defaultRequest(_ api: API) -> Single<Response> {
        return provider.rx.request(api)
            .timeout(.seconds(10), scheduler: MainScheduler.asyncInstance)
            .catch { error in
                guard let errorCode = (error as? MoyaError)?.response?.statusCode else {
                    if let moyaError = (error as? MoyaError), moyaError.errorCode == 6 {
                        return Single.error(api.errorMap[1009] ?? error)
                    }
                    return Single.error(error)
                }
                return Single.error(api.errorMap[errorCode] ?? error)
            }
    }

    func authorizedRequest(_ api: API) -> Single<Response> {
        guard checkTokenIsExist() else {
            return defaultRequest(api)
        }

        guard checkAccessTokenIsValid() else {
            return reissueToken()
                .andThen(defaultRequest(api))
                .retry(maxRetryCount)
        }

        return defaultRequest(api)
    }

    func checkIsApiNeedsAuthorization(_ api: API) -> Bool {
        api.jwtTokenType == .accessToken
    }

    func checkAccessTokenIsValid() -> Bool {
        guard let expired = Double(keychain.load(type: .accessExpiresIn)) else { return false }
        let today = Date()
        let expiredDate = (expired / 1000.0).unixTimeToDate
        return today < expiredDate
    }

    func checkTokenIsExist() -> Bool {
        !keychain.load(type: .accessToken).isEmpty || !keychain.load(type: .refreshToken).isEmpty
    }

    func reissueToken() -> Completable {
        return refreshProvider.rx.request(.refresh)
            .asCompletable()
    }
}
