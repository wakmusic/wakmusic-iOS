//
//  SearchViewModel.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/01/05.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import AuthDomainInterface
import AuthenticationServices
import BaseFeature
import CryptoSwift
import KeychainModule
import LogManager
import NaverThirdPartyLogin
import RxCocoa
import RxRelay
import RxSwift
import UserDomainInterface
import Utility

public final class LoginViewModel: NSObject, ViewModelType { // 네이버 델리게이트를 받기위한 NSObject 상속
    private let disposeBag = DisposeBag()

    private var fetchTokenUseCase: FetchTokenUseCase
    private var fetchUserInfoUseCase: FetchUserInfoUseCase

    let googleLoginManager = GoogleLoginManager.shared
    let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    let oauthToken: PublishRelay<(ProviderType, String)> = PublishRelay()
    let fetchedWMToken: PublishRelay<String> = PublishRelay()
    let isErrorString: PublishRelay<String> = PublishRelay() // 에러를 아웃풋에 반환해 주기 위한 작업
    let keychain = KeychainImpl()
    let getGoogleTokenToSafariDismiss: PublishSubject<Void> = PublishSubject()

    public struct Input {
        let pressNaverLoginButton: PublishRelay<Void>
        let pressAppleLoginButton: PublishRelay<Void>
    }

    public struct Output {
        let showErrorToast: PublishRelay<String> = .init()
        let shouldDismiss: PublishRelay<Void> = .init()
    }

    public init(
        fetchTokenUseCase: FetchTokenUseCase,
        fetchUserInfoUseCase: FetchUserInfoUseCase
    ) {
        self.fetchTokenUseCase = fetchTokenUseCase
        self.fetchUserInfoUseCase = fetchUserInfoUseCase
        super.init()
        self.googleLoginManager.googleOAuthLoginDelegate = self
        self.naverLoginInstance?.delegate = self
    }

    public func transform(from input: Input) -> Output {
        let output = Output()
        inputTransfrom(input: input)

        // MARK: (Naver, Google, Apple)Token WMToken으로 치환
        oauthToken
            .debug("🚚 oauthToken")
            .filter { !$0.1.isEmpty }
            .flatMap { [fetchTokenUseCase] provider, token in
                fetchTokenUseCase.execute(providerType: provider, token: token)
                    .catch { (error: Error) in
                        return Single.error(error)
                    }
                    .asObservable()
            }
            .flatMap { [fetchUserInfoUseCase] _ in
                fetchUserInfoUseCase.execute()
                    .catch { (error: Error) in
                        return Single.error(error)
                    }
                    .asObservable()
            }
            .subscribe(onNext: { entity in
                LogManager.setUserID(userID: entity.id)
                PreferenceManager.shared.setUserInfo(
                    ID: AES256.encrypt(string: entity.id),
                    platform: entity.platform,
                    profile: entity.profile,
                    name: AES256.encrypt(string: entity.name),
                    version: entity.version
                )
                output.shouldDismiss.accept(())
            }, onError: { error in
                let error = error.asWMError
                output.showErrorToast.accept(error.errorDescription ?? "알수 없는 오류가 발생하였습니다.")
                output.shouldDismiss.accept(())
            }).disposed(by: disposeBag)

        return output
    }

    // MARK: Input Binding
    func inputTransfrom(input: Input) {
        input.pressNaverLoginButton
            .bind {
                self.naverLoginInstance?.delegate = self
                self.naverLoginInstance?.requestThirdPartyLogin() // requestDeleteToken() <- 로그아읏
            }.disposed(by: disposeBag)

        input.pressAppleLoginButton.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let appleIdProvider = ASAuthorizationAppleIDProvider()
            let request = appleIdProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let auth = ASAuthorizationController(authorizationRequests: [request])
            auth.delegate = self
            auth.presentationContextProvider = self
            auth.performRequests()
        }).disposed(by: disposeBag)
    }
}

// MARK: - GoogleOAuthLoginDelegate를 이용하여 code 받기
extension LoginViewModel: GoogleOAuthLoginDelegate {
    public func requestGoogleAccessToken(_ code: String) {
        Task {
            let id = try await GoogleLoginManager.shared.getGoogleOAuthToken(code)
            oauthToken.accept((.google, id))
            getGoogleTokenToSafariDismiss.onNext(())
        }
    }
}

// MARK: - NaverThirdPartyLoginConnectionDelegate
extension LoginViewModel: NaverThirdPartyLoginConnectionDelegate {
    public func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        guard let accessToken = naverLoginInstance?.isValidAccessTokenExpireTimeNow() else { return }
        if !accessToken { return }
        guard let accessToken = naverLoginInstance?.accessToken else { return }
        oauthToken.accept((.naver, accessToken))
    }

    public func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        guard let accessToken = naverLoginInstance?.isValidAccessTokenExpireTimeNow() else { return }
        if !accessToken { return }
        guard let accessToken = naverLoginInstance?.accessToken else { return }
        oauthToken.accept((.naver, accessToken))
    }

    public func oauth20ConnectionDidFinishDeleteToken() {
        DEBUG_LOG("네이버 로그아웃")
    }

    public func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        isErrorString.accept(error.localizedDescription)
    }
}

// MARK: - AppleLoginDelegate
extension LoginViewModel: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.last ?? .init()
    }

    public func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
           let rawData = credential.identityToken {
            let token = String(decoding: rawData, as: UTF8.self)
            oauthToken.accept((.apple, token))
        }
    }

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        isErrorString.accept(error.localizedDescription)
    }
}
