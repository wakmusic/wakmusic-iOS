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

// MARK: - Delegate protocol
public protocol GoogleOAuthLoginDelegate: AnyObject {
    func requestGoogleAccessToken(_ code: String)
}

// MARK: - Google Error
public enum WMGoogleError: Error {
    case decodeError
    case internalError
}

public class GoogleLoginManager {
    // MARK: - 변수 선언
    private let googleURL = "https://accounts.google.com/o/oauth2/v2/auth"
    private let accessTokenGoogleURL = "https://oauth2.googleapis.com"
    private let getProfileURL = "https://www.googleapis.com/oauth2/v1/userinfo"
    private let googleClientID = GOOGLE_CLIENT_ID()
    private let googleSecretKey = GOOGLE_SECRET_KEY()
    private let googleURLScheme = GOOGLE_URL_SCHEME()
    private let scope = "profile"

    private let pkce = try? PKCE()
    public static let shared = GoogleLoginManager()
    private let disposeBag = DisposeBag()
    public weak var googleOAuthLoginDelegate: GoogleOAuthLoginDelegate?

    // MARK: - 사파리로 로그인 URL 보내기
    public func googleLoginRequest() {
        var components = URLComponents(string: googleURL)

        let scope = URLQueryItem(name: "scope", value: scope)
        let responseType = URLQueryItem(name: "response_type", value: "code")
        let redirectURI = URLQueryItem(name: "redirect_uri", value: "\(googleURLScheme):redirect_uri_path")
        let clientID = URLQueryItem(name: "client_id", value: googleClientID)
        let codeChallenge = URLQueryItem(name: "code_challenge", value: pkce?.codeChallenge)
        let codeChallengeMethod = URLQueryItem(name: "code_challenge_method", value: "S256")
        
        components?.queryItems = [scope, responseType, codeChallenge, redirectURI, clientID, codeChallengeMethod]

        if let url = components?.url, UIApplication.shared.canOpenURL(url) {
            DEBUG_LOG(url)
            UIApplication.shared.open(url)
        }
    }

    // MARK: - URL 뒤의 Token catch
    public func getGoogleToken(_ url: URL) {
        let components = URLComponents(string: "\(url)")
        let items = components?.queryItems ?? []
        googleOAuthLoginDelegate?.requestGoogleAccessToken(items[0].value ?? "")
    }

    // MARK: - Google Oauth 서버로 access_token get하기
    public func getGoogleOAuthToken(_ code: String) async throws -> String {
        let parameters: Parameters = [
            "client_id": googleClientID,
            "code": code,
            "code_verifier": pkce?.codeVerifier ?? "",
            "redirect_uri": "\(googleURLScheme):redirect_uri_path",
            "grant_type": "authorization_code"
        ]

        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                accessTokenGoogleURL + "/token",
                method: .post,
                parameters: parameters
            )
            .responseData { response in
                switch response.result {
                case .success(let data):
                    let accessToken = try? JSONDecoder().decode(
                        GoogleGetTokenEntity.self,
                        from: data
                    )

                    Task {
                        continuation.resume(
                            returning: try await self
                                .getGoogleUserInfo(accessToken?.accessToken ?? "")
                        )
                    }

                case .failure(let error):
                    DEBUG_LOG(error)
                    continuation.resume(throwing: WMGoogleError.internalError)

                }
            }
        }
    }

    // MARK: - Google한테 유저 정보 받아오기
    func getGoogleUserInfo(_ accessToken: String) async throws -> String {
        let parameters: Parameters = [
            "alt": "json"
        ]
        let headers: HTTPHeaders = [
            .authorization(bearerToken: accessToken)
        ]

        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                getProfileURL,
                method: .get,
                parameters: parameters,
                headers: headers
            )
            .responseData { response in
                switch response.result {
                case .success(let data):
                    let id = try? JSONDecoder().decode(
                        GoogleUserInfoEntity.self,
                        from: data
                    )
                    continuation.resume(returning: id?.id ?? "")

                case .failure:
                    continuation.resume(throwing: WMGoogleError.internalError)

                }
            }
        }
    }
}
