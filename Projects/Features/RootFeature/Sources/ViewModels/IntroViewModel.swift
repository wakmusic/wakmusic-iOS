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
import DataMappingModule

public struct AppInfoResult {
    let title: String
    let message: String
    let flag: AppInfoFlagType
}

final public class IntroViewModel: ViewModelType {

    var disposeBag = DisposeBag()
    var fetchUserInfoUseCase : FetchUserInfoUseCase!
    var fetchCheckAppUseCase: FetchCheckAppUseCase!

    public struct Input {
    }

    public struct Output {
        var showAlert: PublishSubject<String> = PublishSubject()
        var showErrorPopup: PublishSubject<Bool> = PublishSubject()
        var appInfoResult: PublishSubject<AppInfoResult> = PublishSubject()
    }

    public init(
        fetchUserInfoUseCase: FetchUserInfoUseCase,
        fetchCheckAppUseCase: FetchCheckAppUseCase
    ) {
        self.fetchUserInfoUseCase = fetchUserInfoUseCase
        self.fetchCheckAppUseCase = fetchCheckAppUseCase
        DEBUG_LOG("✅ \(Self.self) 생성")
    }
    
    public func transform(from input: Input) -> Output {
        let output = Output()
        
        self.fetchCheckAppUseCase.execute()
            .catchAndReturn(AppInfoEntity(flag: .normal, title: "", description: "", version: ""))
            .asObservable()
            .debug("✅ Intro > fetchCheckAppUseCase")
            .map{ (entity:AppInfoEntity) -> AppInfoResult in
                var appInfoResult: AppInfoResult
                
                switch entity.flag {
                case .normal:
                    appInfoResult = AppInfoResult(title: "", message: "", flag: .normal)
                case .event:
                    appInfoResult = AppInfoResult(title: entity.title, message: entity.description, flag: .event)
                case .update:
                    appInfoResult = AppInfoResult(title: "", message: "", flag: .update)
                case .forceUpdate:
                    appInfoResult = AppInfoResult(title: "", message: "", flag: .forceUpdate)
                }
                return appInfoResult
            }
            .bind(to: output.appInfoResult)
            .disposed(by: disposeBag)
        
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
