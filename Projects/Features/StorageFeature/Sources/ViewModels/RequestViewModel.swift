//
//  AfterLoginStorageViewModel.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/26.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import Utility
import RxSwift
import RxRelay
import DomainModule
import BaseFeature
import KeychainModule

final public class RequestViewModel:ViewModelType {

    var disposeBag = DisposeBag()
    var withDrawUserInfoUseCase: WithdrawUserInfoUseCase

    public struct Input {
        let pressWithdraw:PublishSubject<Void> = PublishSubject()
    }

    public struct Output {
        let withDrawResult: PublishSubject<BaseEntity> = PublishSubject()
    }

    public init(
        withDrawUserInfoUseCase:WithdrawUserInfoUseCase
    ) {
        
        self.withDrawUserInfoUseCase = withDrawUserInfoUseCase
        DEBUG_LOG("✅ \(Self.self) 생성")
    }
    
    public func transform(from input: Input) -> Output {
        let output = Output()
     
        input.pressWithdraw
            .debug("pressWithdraw")
            .flatMap{ [weak self] () -> Observable<BaseEntity> in
                guard let self = self else {
                    return Observable.empty()
                }
                return self.withDrawUserInfoUseCase.execute()
                    .catch{ (error) in
                        return Single<BaseEntity>.create { single in
                            single(.success(BaseEntity(status: 0, description: error.asWMError.errorDescription ?? "")))
                            return Disposables.create {}
                        }
                    }.asObservable()
            }
            .do(onNext: { (model) in
                DEBUG_LOG("성공성공성공: \(model)")
                let keychain = KeychainImpl()
                keychain.delete(type: .accessToken)
                Utility.PreferenceManager.userInfo = nil
            })
            .bind(to: output.withDrawResult)
            .disposed(by: disposeBag)

        return output
    }
}
