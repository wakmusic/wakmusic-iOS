//
//  AfterLoginStorageViewModel.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/26.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import AuthDomainInterface
import BaseDomainInterface
import BaseFeature
import Foundation
import NaverThirdPartyLogin
import RxRelay
import RxSwift
import UserDomainInterface
import Utility

public final class RequestViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    var withDrawUserInfoUseCase: WithdrawUserInfoUseCase
    private let logoutUseCase: any LogoutUseCase
    let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()

    public struct Input {
        let pressWithdraw: PublishSubject<Void> = PublishSubject()
    }

    public struct Output {
        let withDrawResult: PublishSubject<BaseEntity> = PublishSubject()
    }

    public init(
        withDrawUserInfoUseCase: WithdrawUserInfoUseCase,
        logoutUseCase: any LogoutUseCase
    ) {
        self.withDrawUserInfoUseCase = withDrawUserInfoUseCase
        self.logoutUseCase = logoutUseCase
        DEBUG_LOG("✅ \(Self.self) 생성")
    }

    public func transform(from input: Input) -> Output {
        let output = Output()

        input.pressWithdraw
            .debug("pressWithdraw")
            .flatMap { [withDrawUserInfoUseCase] () -> Observable<BaseEntity> in
                return withDrawUserInfoUseCase.execute()
                    .catch { error in
                        let baseEntity = BaseEntity(status: 0, description: error.asWMError.errorDescription ?? "")
                        return Single<BaseEntity>.just(baseEntity)
                    }
                    .asObservable()
            }
            .flatMap { [naverLoginInstance, logoutUseCase] entity in
                let platform = Utility.PreferenceManager.userInfo?.platform

                if platform == "naver" {
                    naverLoginInstance?.requestDeleteToken()
                }

                return logoutUseCase.execute()
                    .andThen(Single.just(entity))
                    .catch { error in
                        let baseEntity = BaseEntity(status: 0, description: error.asWMError.errorDescription ?? "")
                        return Single<BaseEntity>.just(baseEntity)
                    }
            }
            .bind(to: output.withDrawResult)
            .disposed(by: disposeBag)

        return output
    }
}
