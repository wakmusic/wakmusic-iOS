//
//  IntroViewModel.swift
//  RootFeature
//
//  Created by KTH on 2023/03/24.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import Utility
import RxSwift
import RxCocoa
import DomainModule
import BaseFeature
import KeychainModule
import ErrorModule

final public class IntroViewModel: ViewModelType {

    var disposeBag = DisposeBag()
    var fetchUserInfoUseCase : FetchUserInfoUseCase!
    var fetchCheckVersionUseCase: FetchCheckVersionUseCase!

    public struct Input {
    }

    public struct Output {
        var showAlert: PublishSubject<String> = PublishSubject()
    }

    public init(
        fetchUserInfoUseCase: FetchUserInfoUseCase,
        fetchCheckVersionUseCase: FetchCheckVersionUseCase
    ) {
        self.fetchUserInfoUseCase = fetchUserInfoUseCase
        self.fetchCheckVersionUseCase = fetchCheckVersionUseCase
        DEBUG_LOG("✅ \(Self.self) 생성")
    }
    
    public func transform(from input: Input) -> Output {
        let output = Output()

        Utility.PreferenceManager.$userInfo
            .delay(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .take(1)
            .filter{ (userInfo) in
                guard userInfo != nil else {
                    output.showAlert.onNext("")
                    return false
                }
                return true
            }
            .flatMap { [weak self] _ -> Observable<AuthUserInfoEntity> in
                guard let `self` = self else { return Observable.empty() }
                return self.fetchUserInfoUseCase.execute()
                    .asObservable()
            }
            .debug("✅ Intro > fetchUserInfoUseCase")
            .subscribe(onNext: { _ in
                output.showAlert.onNext("")
            }, onError: { (error) in
                let asWMError = error.asWMError
                if asWMError == .tokenExpired {
                    let keychain = KeychainImpl()
                    keychain.delete(type: .accessToken)
                    Utility.PreferenceManager.userInfo = nil
                    Utility.PreferenceManager.startPage = 4
                    output.showAlert.onNext(asWMError.errorDescription ?? "")
                }else if asWMError == .unknown {
                    output.showAlert.onNext(asWMError.errorDescription ?? "")
                }else{
                    output.showAlert.onNext(error.localizedDescription)
                }
            }).disposed(by: disposeBag)
        
        return output
    }
}
