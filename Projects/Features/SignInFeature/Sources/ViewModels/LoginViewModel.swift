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
import DomainModule
import Utility
import NaverThirdPartyLogin
import KeychainModule
import CryptoSwift
import AuthenticationServices

public final class LoginViewModel: NSObject, ViewModelType { // 네이버 델리게이트를 받기위한 NSObject 상속
    private let disposeBag = DisposeBag()

    private var fetchTokenUseCase: FetchTokenUseCase!
    private var fetchNaverUserInfoUseCase: FetchNaverUserInfoUseCase!
    private var fetchUserInfoUseCase: FetchUserInfoUseCase!

    let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    let naverToken: PublishRelay<(String,String)> = PublishRelay()
    let googleToken: PublishRelay<String> = PublishRelay()
    let appleToken: PublishRelay<String> = PublishRelay() // 각각의 토큰은 뷰모델에서만 처리, input, output에서 제거
    let fetchedWMToken: PublishRelay<String> = PublishRelay()

    let isErrorString: PublishRelay<String> = PublishRelay() // 에러를 아웃풋에 반환해 주기 위한 작업
    let keychain = KeychainImpl()

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
        self.naverLoginInstance?.delegate = self
        self.fetchTokenUseCase = fetchTokenUseCase
        self.fetchNaverUserInfoUseCase = fetchNaverUserInfoUseCase
        self.fetchUserInfoUseCase = fetchUserInfoUseCase
    }

    public func transform(from input: Input) -> Output {
        let showErrorToast = PublishRelay<String>()

        inputTransfrom(input: input)

        naverToken
            .flatMap{ [weak self] (tokenType: String, accessToken: String) -> Observable<NaverUserInfoEntity> in
                guard let self = self else { return Observable.empty() }
                return self.fetchNaverUserInfoUseCase.execute(
                    tokenType: tokenType,
                    accessToken: accessToken
                )
                .catchAndReturn(NaverUserInfoEntity(resultcode: "", message: "", id: "", nickname: ""))
                .asObservable()
            }
            .filter{ !$0.id.isEmpty }
            .map{ $0.id }
            .withUnretained(self)
            .flatMap { (viewModel, id) -> Observable<AuthLoginEntity> in
                return viewModel.fetchTokenUseCase.execute(id: id, type: .naver)
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
        
        appleToken
            .filter{ !$0.isEmpty }
            .withUnretained(self)
            .flatMap { (viewModel, id) -> Observable<AuthLoginEntity> in
                return viewModel.fetchTokenUseCase.execute(id: id, type: .apple)
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
            .debug("test")
            .flatMap { _ -> Observable<AuthUserInfoEntity> in
                return self.fetchUserInfoUseCase.execute()
                    .catchAndReturn(
                        AuthUserInfoEntity(
                            id: "",
                            platform: "apple",
                            displayName: "ifari",
                            first_login_time: 0,
                            first: false,
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
                    displayName: AES256.encrypt(string: $0.displayName),
                    firstLoginTime: $0.first_login_time,
                    first: $0.first,
                    version: $0.version
                )
            })
            .disposed(by: disposeBag)

        return Output(showErrorToast: showErrorToast)
    }
    func inputTransfrom(input: Input) {
        input.pressNaverLoginButton
            .bind {
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

extension LoginViewModel: NaverThirdPartyLoginConnectionDelegate {
    public func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        guard let accessToken = naverLoginInstance?.isValidAccessTokenExpireTimeNow() else { return }
        if !accessToken { return }
        guard let tokenType = naverLoginInstance?.tokenType else { return }
        guard let accessToken = naverLoginInstance?.accessToken else { return }
        DEBUG_LOG(tokenType)
        DEBUG_LOG(accessToken)
        naverToken.accept((tokenType, accessToken))
    }
    
    public func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        guard let accessToken = naverLoginInstance?.isValidAccessTokenExpireTimeNow() else { return }
        if !accessToken { return }
        guard let tokenType = naverLoginInstance?.tokenType else { return }
        guard let accessToken = naverLoginInstance?.accessToken else { return }
        DEBUG_LOG(tokenType)
        DEBUG_LOG(accessToken)

        naverToken.accept((tokenType, accessToken))
    }
    
    public func oauth20ConnectionDidFinishDeleteToken() {
        DEBUG_LOG("네이버 로그아웃")
    }
    
    public func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        isErrorString.accept(error.localizedDescription)
    }
}

extension LoginViewModel: ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.last!
    }

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifer = credential.user
            appleToken.accept(userIdentifer)
        }
    }

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        isErrorString.accept(error.localizedDescription)
    }
}
