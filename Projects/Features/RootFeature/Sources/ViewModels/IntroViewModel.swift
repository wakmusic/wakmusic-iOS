//
//  IntroViewModel.swift
//  RootFeature
//
//  Created by KTH on 2023/03/24.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import AppDomainInterface
import BaseFeature
import DataMappingModule
import DomainModule
import ErrorModule
import Foundation
import KeychainModule
import RxCocoa
import RxSwift
import Utility
import UserDomainInterface

public final class IntroViewModel: ViewModelType {
    var fetchUserInfoUseCase: FetchUserInfoUseCase!
    var fetchAppCheckUseCase: FetchAppCheckUseCase!
    var disposeBag = DisposeBag()

    public struct Input {
        var fetchPermissionCheck: PublishSubject<Void> = PublishSubject()
        var fetchAppCheck: PublishSubject<Void> = PublishSubject()
        var fetchUserInfoCheck: PublishSubject<Void> = PublishSubject()
        var endedLottieAnimation: PublishSubject<Void> = PublishSubject()
    }

    public struct Output {
        var permissionResult: PublishSubject<Bool?> = PublishSubject()
        var appInfoResult: PublishSubject<Result<AppCheckEntity, Error>> = PublishSubject()
        var userInfoResult: PublishSubject<Result<String, Error>> = PublishSubject()
        var endedLottieAnimation: PublishSubject<Void> = PublishSubject()
    }

    public init(
        fetchUserInfoUseCase: FetchUserInfoUseCase,
        fetchAppCheckUseCase: FetchAppCheckUseCase
    ) {
        self.fetchUserInfoUseCase = fetchUserInfoUseCase
        self.fetchAppCheckUseCase = fetchAppCheckUseCase
        DEBUG_LOG("✅ \(Self.self) 생성")
    }

    public func transform(from input: Input) -> Output {
        let output = Output()

        Observable.combineLatest(
            input.fetchPermissionCheck,
            Utility.PreferenceManager.$appPermissionChecked
        ) { _, permission -> Bool? in
            return permission
        }
        .bind(to: output.permissionResult)
        .disposed(by: disposeBag)

        input.endedLottieAnimation
            .bind(to: output.endedLottieAnimation)
            .disposed(by: disposeBag)

        input.fetchAppCheck
            .flatMap { [weak self] _ -> Observable<AppCheckEntity> in
                guard let self else { return Observable.empty() }
                return self.fetchAppCheckUseCase.execute()
                    .catch { error -> Single<AppCheckEntity> in
                        let wmError = error.asWMError
                        if wmError == .offline {
                            return Single<AppCheckEntity>.create { single in
                                single(
                                    .success(
                                        AppCheckEntity(
                                            flag: .offline,
                                            title: "",
                                            description: wmError.errorDescription ?? "",
                                            version: "",
                                            specialLogo: false
                                        )
                                    )
                                )
                                return Disposables.create()
                            }
                        } else {
                            return Single.error(error)
                        }
                    }
                    .asObservable()
            }
            .debug("✅ Intro > fetchCheckAppUseCase")
            .subscribe(onNext: { model in
                output.appInfoResult.onNext(.success(model))
            }, onError: { error in
                output.appInfoResult.onNext(.failure(error))
            })
            .disposed(by: disposeBag)

        input.fetchUserInfoCheck
            .withLatestFrom(Utility.PreferenceManager.$userInfo)
            .filter { userInfo in
                guard userInfo != nil else {
                    // 비로그인 상태인데, 키체인에 저장된 엑세스 토큰이 살아있다는건 로그인 상태로 앱을 삭제한 유저임
                    let keychain = KeychainImpl()
                    let accessToken = keychain.load(type: .accessToken)
                    if !accessToken.isEmpty {
                        DEBUG_LOG("💡 비로그인 상태입니다. 엑세스 토큰을 삭제합니다.")
                        keychain.delete(type: .accessToken)
                    }
                    output.userInfoResult.onNext(.success(""))
                    return false
                }
                return true
            }
            .flatMap { [weak self] _ -> Observable<UserInfoEntity> in
                guard let `self` = self else { return Observable.empty() }
                return self.fetchUserInfoUseCase.execute()
                    .asObservable()
            }
            .debug("✅ Intro > fetchUserInfoUseCase")
            .subscribe(onNext: { _ in
                output.userInfoResult.onNext(.success(""))
            }, onError: { error in
                let asWMError = error.asWMError
                if asWMError == .tokenExpired || asWMError == .notFound {
                    let keychain = KeychainImpl()
                    keychain.delete(type: .accessToken)
                    Utility.PreferenceManager.userInfo = nil
                    Utility.PreferenceManager.startPage = 4
                }
                output.userInfoResult.onNext(.failure(error))
            }).disposed(by: disposeBag)

        return output
    }
}
