//
//  SearchViewModel.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/01/05.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import RxSwift
import RxRelay
import BaseFeature
import Utility
import NaverThirdPartyLogin
import KeychainModule
import CryptoSwift
import AuthenticationServices
import DomainModule
import AuthDomainInterface

public final class LoginViewModel: NSObject, ViewModelType { // 네이버 델리게이트를 받기위한 NSObject 상속
    private let disposeBag = DisposeBag()

    private var fetchTokenUseCase: FetchTokenUseCase!
    private var fetchNaverUserInfoUseCase: FetchNaverUserInfoUseCase!
    private var fetchUserInfoUseCase: FetchUserInfoUseCase!

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
        let showErrorToast: PublishRelay<String>
    }

    public init(
        fetchTokenUseCase: FetchTokenUseCase,
        fetchNaverUserInfoUseCase: FetchNaverUserInfoUseCase,
        fetchUserInfoUseCase: FetchUserInfoUseCase
    ){
        super.init()
        self.googleLoginManager.googleOAuthLoginDelegate = self
        self.naverLoginInstance?.delegate = self
        self.fetchTokenUseCase = fetchTokenUseCase
        self.fetchNaverUserInfoUseCase = fetchNaverUserInfoUseCase
        self.fetchUserInfoUseCase = fetchUserInfoUseCase
    }

    public func transform(from input: Input) -> Output {
        let showErrorToast = PublishRelay<String>()
        inputTransfrom(input: input)
        
        // MARK: (Naver, Google, Apple)Token WMToken으로 치환
        oauthToken
            .debug("🚚 oauthToken")
            .filter{ !$0.1.isEmpty }
            .withUnretained(self)
            .flatMap { (viewModel, id) -> Observable<AuthLoginEntity> in
                let (providerType, token) = id
                return viewModel.fetchTokenUseCase.execute(token: token, type: providerType)
                    .catchAndReturn(AuthLoginEntity(token: ""))
                    .asObservable()
            }
            .map { $0.token }
            .filter { !$0.isEmpty }
            .do(onNext: {
                self.keychain.save(type: .accessToken, value: $0)
            })
            .bind(to: fetchedWMToken)
            .disposed(by: disposeBag)

        // MARK: WM 로그인 이후 얻은 토큰으로 유저 정보 조회 및 저장
        fetchedWMToken
            .debug("🚚 fetchedWMToken")
            .flatMap { _ -> Observable<UserInfoEntity> in
                return self.fetchUserInfoUseCase.execute()
                    .catchAndReturn(
                        UserInfoEntity(
                            id: "",
                            platform: "apple",
                            name: "ifari",
                            profile: "panchi",
                            version: 1
                        )
                    )
                    .asObservable()
            }
            .subscribe(onNext: {
                PreferenceManager.shared.setUserInfo(
                    ID: AES256.encrypt(string: $0.id),
                    platform: $0.platform,
                    profile: $0.profile,
                    name: AES256.encrypt(string: $0.name),
                    version: $0.version
                )
            })
            .disposed(by: disposeBag)

        return Output(showErrorToast: showErrorToast)
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
            request.requestedScopes = [.fullName,.email]
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
extension LoginViewModel: ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.last!
    }

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
           let rawData =  credential.identityToken {
            let token = String(decoding: rawData, as: UTF8.self)
            oauthToken.accept((.apple, token))
        }
    }

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        isErrorString.accept(error.localizedDescription)
    }
}
