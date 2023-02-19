import APIKit
import ErrorModule
import Foundation
import KeychainModule
import RxSwift
import Moya
import RxMoya
import Utility

public class BaseRemoteDataSource<API: WMAPI> {
    private let keychain: any Keychain
    private let provider: MoyaProvider<API>
    private let decoder = JSONDecoder()
    private let maxRetryCount = 2

    public init(
        keychain: any Keychain,
        provider: MoyaProvider<API>? = nil
    ) {
        self.keychain = keychain

        #if DEV
        self.provider = provider ?? MoyaProvider(plugins: [JwtPlugin(keychain: keychain), CustomLoggingPlugin()])
        #else
        self.provider = provider ?? MoyaProvider(plugins: [JwtPlugin(keychain: keychain)])
        #endif
    }

    public func request(_ api: API) -> Single<Response> {
        return Single<Response>.create { single in
            var disposabels = [Disposable]()
            disposabels.append(
                self.defaultRequest(api).subscribe(
                    onSuccess: { single(.success($0)) },
                    onFailure: { single(.failure($0)) })
            )
            return Disposables.create(disposabels)
        }
    }
}

private extension BaseRemoteDataSource {
    func defaultRequest(_ api: API) -> Single<Response> {
        DEBUG_LOG("[\(api.method.rawValue)] \(api.baseURL.absoluteString + api.domain.rawValue + api.urlPath)\n\(api.task)")
        return provider.rx.request(api)
            .timeout(.seconds(5), scheduler: MainScheduler.asyncInstance)
            .catch { error in
                guard let errorCode = (error as? MoyaError)?.response?.statusCode else {
                    return Single.error(error)
                }
                return Single.error(api.errorMap[errorCode] ?? error)
            }
    }

    func checkIsApiNeedsAuthorization(_ api: API) -> Bool {
        api.jwtTokenType == .accessToken
    }
}
