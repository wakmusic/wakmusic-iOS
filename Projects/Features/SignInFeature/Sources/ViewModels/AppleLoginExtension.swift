//
//  AppleLoginExtension.swift
//  SignInFeature
//
//  Created by 김대희 on 2023/03/13.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import AuthenticationServices
import Foundation
import Utility

extension LoginViewModel:ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding{

    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.last!
    }

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifer = credential.user
            DEBUG_LOG(userIdentifer)
            appleToken.onNext(userIdentifer)
        }
    }

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        DEBUG_LOG("Apple Login Fail")

        input.showErrorToast
            .accept(error.localizedDescription)
    }
}
