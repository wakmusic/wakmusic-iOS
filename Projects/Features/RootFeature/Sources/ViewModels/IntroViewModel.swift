//
//  IntroViewModel.swift
//  RootFeature
//
//  Created by KTH on 2023/03/24.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import AppDomainInterface
import AuthDomainInterface
import BaseFeature
import ErrorModule
import Foundation
import LogManager
import RxCocoa
import RxSwift
import UserDomainInterface
import Utility

public final class IntroViewModel: ViewModelType {
    private let fetchUserInfoUseCase: FetchUserInfoUseCase
    private let fetchAppCheckUseCase: FetchAppCheckUseCase
    private let logoutUseCase: any LogoutUseCase
    private let checkIsExistAccessTokenUseCase: any CheckIsExistAccessTokenUseCase
    private let disposeBag = DisposeBag()

    public struct Input {
        let fetchPermissionCheck: PublishSubject<Void> = PublishSubject()
        let fetchAppCheck: PublishSubject<Void> = PublishSubject()
        let checkUserInfoPreference: PublishSubject<Void> = PublishSubject()
    }

    public struct Output {
        let confirmedPermission: PublishSubject<Bool?> = PublishSubject()
        let confirmedAppInfo: PublishSubject<Result<AppCheckEntity, Error>> = PublishSubject()
        let confirmedUserInfoPreference: PublishSubject<Result<Void, Error>> = PublishSubject()
        let endedLottieAnimation: PublishSubject<Void> = PublishSubject()
    }

    public init(
        fetchUserInfoUseCase: FetchUserInfoUseCase,
        fetchAppCheckUseCase: FetchAppCheckUseCase,
        logoutUseCase: any LogoutUseCase,
        checkIsExistAccessTokenUseCase: any CheckIsExistAccessTokenUseCase
    ) {
        self.fetchUserInfoUseCase = fetchUserInfoUseCase
        self.fetchAppCheckUseCase = fetchAppCheckUseCase
        self.logoutUseCase = logoutUseCase
        self.checkIsExistAccessTokenUseCase = checkIsExistAccessTokenUseCase
    }

    public func transform(from input: Input) -> Output {
        let output = Output()

        Observable.combineLatest(
            input.fetchPermissionCheck,
            Utility.PreferenceManager.$appPermissionChecked
        ) { _, permission -> Bool? in
            return permission
        }
        .bind(to: output.confirmedPermission)
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
                output.confirmedAppInfo.onNext(.success(model))
            }, onError: { error in
                output.confirmedAppInfo.onNext(.failure(error))
            })
            .disposed(by: disposeBag)

        input.checkUserInfoPreference
            .withLatestFrom(PreferenceManager.$userInfo)
            .flatMap { [logoutUseCase, checkIsExistAccessTokenUseCase] userInfo -> Observable<Void> in
                // 비로그인 상태인데, 키체인에 저장된 엑세스 토큰이 살아있다는건 로그인 상태로 앱을 삭제한 유저임
                guard userInfo == nil else {
                    return Observable.just(())
                }
                return checkIsExistAccessTokenUseCase.execute()
                    .asObservable()
                    .flatMap { isExist in
                        isExist ? logoutUseCase.execute(localOnly: true)
                            .andThen(Observable.just(())) : Observable.just(())
                    }
            }
            .debug("✅ Intro > checkIsExistUseInfoPreference")
            .subscribe(onNext: { _ in
                output.confirmedUserInfoPreference.onNext(.success(()))

            }, onError: { error in
                output.confirmedUserInfoPreference.onNext(.failure(error))
            })
            .disposed(by: disposeBag)

        return output
    }
}
