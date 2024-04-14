//
//  AfterLoginStorageViewModel.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/26.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import AuthDomainInterface
import BaseFeature
import CommonFeature
import Foundation
import KeychainModule
import NaverThirdPartyLogin
import RxRelay
import RxSwift
import UserDomainInterface
import Utility

public final class AfterLoginViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    var fetchUserInfoUseCase: FetchUserInfoUseCase!
    private let logoutUseCase: any LogoutUseCase
    let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()

    public struct Input {
        let textString: BehaviorRelay<String> = BehaviorRelay(value: "")
        let pressLogOut: PublishRelay<Void> = PublishRelay()
    }

    public struct Output {
        let state: BehaviorRelay<EditState> = BehaviorRelay(value: EditState(isEditing: false, force: true))
        let userInfo: BehaviorRelay<UserInfo?> = BehaviorRelay(value: nil)
    }

    public init(
        fetchUserInfoUseCase: FetchUserInfoUseCase,
        logoutUseCase: any LogoutUseCase
    ) {
        self.fetchUserInfoUseCase = fetchUserInfoUseCase
        self.logoutUseCase = logoutUseCase
        DEBUG_LOG("✅ \(Self.self) 생성")
    }

    public func transform(from input: Input) -> Output {
        let output = Output()

        // MARK: 앱 접속 후 최초 1회는 서버에서 유저 정보를 가져와 동기화 한다. 삭제 후 재설치 한 경우는 제외 함.
        Utility.PreferenceManager.$userInfo
            .filter { $0 != nil }
            .take(1)
            .flatMap { [weak self] _ -> Observable<UserInfoEntity> in
                guard let self = self else { return Observable.empty() }
                return self.fetchUserInfoUseCase.execute()
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
            }).disposed(by: disposeBag)

        input.pressLogOut
            .compactMap { PreferenceManager.userInfo?.platform }
            .flatMap { [naverLoginInstance, logoutUseCase] platform in
                switch platform {
                case "naver":
                    naverLoginInstance?.resetToken()
                    return Observable.just(())

                case "apple":
                    return logoutUseCase.execute()
                        .andThen(Observable.just(()))

                default:
                    return Observable.just(())
                }
            }
            .bind {}
            .disposed(by: disposeBag)

        return output
    }
}
