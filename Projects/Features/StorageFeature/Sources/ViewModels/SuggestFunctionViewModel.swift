//
//  AfterLoginStorageViewModel.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/26.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import BaseFeature
import DomainModule
import Foundation
import KeychainModule
import RxRelay
import RxSwift
import Utility

public final class SuggestFunctionViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    var suggestFunctionUseCase: SuggestFunctionUseCase

    public struct Input {
        var textString: PublishRelay<String> = PublishRelay()
        var tabConfirm: PublishSubject<Void> = PublishSubject()
    }

    public struct Output {
        var selectedIndex: BehaviorRelay<Int> = BehaviorRelay(value: -2)
        var result: PublishSubject<SuggestFunctionEntity> = PublishSubject()
    }

    public init(
        suggestFunctionUseCase: SuggestFunctionUseCase
    ) {
        self.suggestFunctionUseCase = suggestFunctionUseCase
    }

    deinit {
        DEBUG_LOG("❌ \(Self.self) 소멸")
    }

    public func transform(from input: Input) -> Output {
        let output = Output()

        let resultObservable = Observable.combineLatest(input.textString, output.selectedIndex)
        input.tabConfirm
            .withLatestFrom(resultObservable)
            .flatMap { [weak self] (text: String, service: Int) -> Observable<SuggestFunctionEntity> in
                guard let self else { return Observable.empty() }
                let userId = AES256.decrypt(encoded: Utility.PreferenceManager.userInfo?.ID ?? "")

                return self.suggestFunctionUseCase
                    .execute(type: (service == 0) ? .mobile : .pc, userID: userId, content: text)
                    .catch { (error: Error) in
                        return Single<SuggestFunctionEntity>.create { single in
                            single(.success(SuggestFunctionEntity(
                                status: 404,
                                message: error.asWMError.errorDescription ?? ""
                            )))
                            return Disposables.create {}
                        }
                    }
                    .asObservable()
                    .map {
                        SuggestFunctionEntity(status: $0.status, message: $0.message)
                    }
            }
            .bind(to: output.result)
            .disposed(by: disposeBag)

        return output
    }
}
