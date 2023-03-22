//
//  GoogleLoginManager.swift
//  Utility
//
//  Created by 김대희 on 2023/03/20.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

public final class GoogleLoginManager {
    private let googleURL = "https://accounts.google.com/o/oauth2/v2/auth"
    private let googleClientID = "715762772031-j0b3uav0md0gqjuiajjahebd9jrc22r8.apps.googleusercontent.com"
    private let googleSecretKey = "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"
    private let scope = "https://www.googleapis.com/auth/userinfo.email"

    public static let shared = GoogleLoginManager()
    private let disposeBag = DisposeBag()

    public func googleLoginRequest() {
        let urlString = "\(googleURL)?scope=\(scope)&response_type=code&redirect_uri=\(REDIRECT_URI())&client_id=\(googleClientID)"
    print(urlString)
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

    public func requestGoogleAccessToken(_ url: String) {
        
    }
}
