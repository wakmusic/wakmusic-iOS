//
//  SearchViewModel.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/01/05.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import BaseFeature
import DomainModule
import Utility
import NaverThirdPartyLogin


public  final class LoginViewModel:NSObject, ViewModelType {
   

    var input = Input()
    var output = Output()
    
    
    let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    var fetchTokenUseCase: FetchTokenUseCase!
    var fetchNaverUserInfo: FetchNaverUserInfoUseCase!
    var disposeBag = DisposeBag()
    var naverToken:PublishSubject<(String,String)> = PublishSubject()
    
    public init(fetchTokenUseCase:FetchTokenUseCase,fetchNaverUserInfo:FetchNaverUserInfoUseCase){
        
        super.init()
        
        self.naverLoginInstance?.delegate = self
        self.fetchTokenUseCase = fetchTokenUseCase
        self.fetchNaverUserInfo = fetchNaverUserInfo
        
        
        
        print("✅ LoginViewModel 생성")
        

        
        input.pressNaverLoginButton
            .debug("PUSH2")
            .subscribe(onNext: {
            
            
            self.naverLoginInstance?.requestThirdPartyLogin()
            //self.naverLoginInstance?.requestDeleteToken() //로그아웃
            
            
        }).disposed(by: disposeBag)
      
        naverToken
            .flatMap{[weak self] (tokenType:String,accessToken:String) -> Observable<NaverUserInfoEntity> in
                
                guard let self = self else{
                    return Observable.empty()
                }
                
               return self.fetchNaverUserInfo.execute(tokenType: tokenType, accessToken: accessToken)
                    .asObservable()
                    .catchAndReturn(NaverUserInfoEntity(resultcode: "", message: "", id: "", nickname: ""))

            }
            .filter({!$0.id.isEmpty})
            .map({$0.id})
            .flatMap { [weak self] (id:String) -> Observable<AuthLoginEntity> in
                
                guard let self = self else{
                    return Observable.empty()
                }
                
                return self.fetchTokenUseCase.execute(id: id, type: .naver)
                    .catchAndReturn(AuthLoginEntity(token: ""))
                    .asObservable()
                    
            }
            .subscribe(onNext: {DEBUG_LOG($0)})
            .disposed(by: disposeBag)
    }

    public struct Input {
        let pressNaverLoginButton:PublishRelay<Void> = PublishRelay()
    }

    public struct Output {
       
    }
    
    public func transform(from input: Input) -> Output {
 
        let output = Output()
        
       
        
        
        return output
    }

}

extension LoginViewModel :NaverThirdPartyLoginConnectionDelegate{
    

    
    public func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
    
        guard let accessToken = naverLoginInstance?.isValidAccessTokenExpireTimeNow() else { return }
                
                if !accessToken {
                  return
                }
                
        guard let tokenType = naverLoginInstance?.tokenType else { return }
        guard let accessToken = naverLoginInstance?.accessToken else { return }
        
        naverToken.onNext((tokenType, accessToken))
        
    }
    
    public func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        
        guard let accessToken = naverLoginInstance?.isValidAccessTokenExpireTimeNow() else { return }
                
                if !accessToken {
                  return
                }
                
        guard let tokenType = naverLoginInstance?.tokenType else { return }
        guard let accessToken = naverLoginInstance?.accessToken else { return }
        
        naverToken.onNext((tokenType, accessToken))
        

    }
    
    public func oauth20ConnectionDidFinishDeleteToken() {
        print("네이버 로그아웃")
    }
    
    public func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("에러 = \(error.localizedDescription)")
    }
    
    
}
