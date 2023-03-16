//
//  NaverLoginExtension.swift
//  SignInFeature
//
//  Created by 김대희 on 2023/03/13.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import NaverThirdPartyLogin
import KeychainModule
import Utility

extension LoginViewModel: NaverThirdPartyLoginConnectionDelegate{
    public func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        guard let accessToken = naverLoginInstance?.isValidAccessTokenExpireTimeNow() else { return }
        if !accessToken { return }
        guard let tokenType = naverLoginInstance?.tokenType else { return }
        guard let accessToken = naverLoginInstance?.accessToken else { return }
        
        naverToken.accept((tokenType, accessToken))
    }
    
    public func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        guard let accessToken = naverLoginInstance?.isValidAccessTokenExpireTimeNow() else { return }
        if !accessToken { return }
        guard let tokenType = naverLoginInstance?.tokenType else { return }
        guard let accessToken = naverLoginInstance?.accessToken else { return }

        naverToken.accept((tokenType, accessToken))
    }
    
    public func oauth20ConnectionDidFinishDeleteToken() {
        DEBUG_LOG("네이버 로그아웃")
    }
    
    public func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        DEBUG_LOG("\(error.localizedDescription)")
        isErrorString.accept(error.localizedDescription)
    }
}
