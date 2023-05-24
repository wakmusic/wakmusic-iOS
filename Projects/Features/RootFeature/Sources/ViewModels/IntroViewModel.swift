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

public enum VersionCheckFlag:Int {
    case noraml = 1
    case event
    case update
    case forceUpdate

}

public struct AppInfoResult {
    
    let title:String
    let message:String
    let flag:VersionCheckFlag
    
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
            .asObservable()
            .map({ [weak self] (entity:AppInfoEntity) -> AppInfoResult in
                guard let self else {return AppInfoResult(title: "", message: "", flag: .noraml) }
                
                var appInfoResult:AppInfoResult
                
                let updateTitle = "왁타버스 뮤직이 업데이트 되었습니다."
                let updateMessage = "최신버전으로 업데이트 후 이용하시기 바랍니다.\n감사합니다."
                
                switch entity.flag {
                        case 1:
                            appInfoResult = AppInfoResult(title: "", message: "", flag: .noraml)
                        case 2:
                            appInfoResult = AppInfoResult(title: entity.title, message: entity.description, flag: .event)
                        
                        case 3:
                            appInfoResult = AppInfoResult(title: updateTitle, message: updateMessage, flag: .update)
                        
                        case 4:
                            appInfoResult = AppInfoResult(title: updateTitle, message: updateMessage, flag: .forceUpdate)
                        
                        default:
                            appInfoResult = AppInfoResult(title: "", message: "", flag: .noraml)
                    
                }
                
                return appInfoResult
                
            })
            .debug("Ahh")
            .bind(to: output.appInfoResult)
            .disposed(by: disposeBag)
        
        
        
        output.appInfoResult
            .subscribe(onNext: {[weak self]  res in
                
                guard let self else {return}
                
                
                if res.flag != .noraml {
                    output.showErrorPopup.onNext(true)
                }
                
                
                
            })
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
