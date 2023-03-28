//
//  GoogleLoginManager.swift
//  Utility
//
//  Created by 김대희 on 2023/03/20.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import RxSwift
import RxRelay

public protocol GoogleOAuthLoginDelegate: AnyObject {
    func requestGoogleAccessToken(_ code: String)
}

public enum WMGoogleError: Error {
    case decodeError
    case internalError
}

public class GoogleLoginManager {
    private let googleURL = "https://accounts.google.com/o/oauth2/v2/auth"
    private let accessTokenGoogleURL = "https://oauth2.googleapis.com"
    private let googleClientID = "715762772031-t7fpm1c6eeccfrcmmo75412kvbljtdhf.apps.googleusercontent.com"
    private let googleSecretKey = "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"
    private let scope = "https://www.googleapis.com/auth/userinfo.email"

    public static let shared = GoogleLoginManager()
    private let disposeBag = DisposeBag()
    public weak var googleOAuthLoginDelegate: GoogleOAuthLoginDelegate?

    public func googleLoginRequest() {
        var components = URLComponents(string: googleURL)

        let scope = URLQueryItem(name: "scope", value: scope)
        let responseType = URLQueryItem(name: "response_type", value: "code")
        let redirectURI = URLQueryItem(name: "redirect_uri", value: "\(REDIRECT_URI()):redirect_uri_path")
        let clientID = URLQueryItem(name: "client_id", value: googleClientID)

        components?.queryItems = [scope, responseType, redirectURI, clientID]
        if let url = components?.url, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

    public func getGoogleToken(_ url: URL) {
        let components = URLComponents(string: "\(url)")
        let items = components?.queryItems ?? []
        googleOAuthLoginDelegate?.requestGoogleAccessToken(items[0].value ?? "")
    }

    public func getGoogleOAuthToken(_ code: String) async throws -> Data {
        let parameters: Parameters = [
            "client_id": googleClientID,
            "client_secret": googleSecretKey,
            "code": code,
            "redirect_uri": "\(REDIRECT_URI()):redirect_uri_path",
            "grant_type": "authorization_code"
        ]

        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                accessTokenGoogleURL + "/token",
                method: .post,
                parameters: parameters
            )
            .responseData { response in
                DEBUG_LOG(String(data: response.request?.httpBody ?? Data(), encoding: .utf8))
                switch response.result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    DEBUG_LOG(error)
                    continuation.resume(throwing: WMGoogleError.internalError)
                }
            }
        }
    }
}
