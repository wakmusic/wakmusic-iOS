//
//  AfterLoginStorageViewModel.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/26.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import Utility
import RxSwift
import RxRelay
import DomainModule
import BaseFeature
import CommonFeature

final public class AfterLoginViewModel:ViewModelType {

    var disposeBag = DisposeBag()
    var fetchUserInfoUseCase : FetchUserInfoUseCase!

    public struct Input {
        let textString:BehaviorRelay<String> = BehaviorRelay(value: "")
    }

    public struct Output {
        let state:BehaviorRelay<EditState> = BehaviorRelay(value:EditState(isEditing: false, force: true))
        let userInfo: BehaviorRelay<UserInfo?> = BehaviorRelay(value: nil)
    }

    public init(
        fetchUserInfoUseCase: FetchUserInfoUseCase
    ) {
        self.fetchUserInfoUseCase = fetchUserInfoUseCase
        DEBUG_LOG("✅ AfterLoginViewModel 생성")
    }
    
    public func transform(from input: Input) -> Output {
        
        let output = Output()

        //MARK: 앱 접속 후 최초 1회는 서버에서 유저 정보를 가져와 동기화 한다. 삭제 후 재설치 한 경우는 제외 함.
        Utility.PreferenceManager.$userInfo
            .filter { $0 != nil }
            .take(1)
            .flatMap { [weak self] _ -> Observable<AuthUserInfoEntity> in
                guard let self = self else { return Observable.empty() }
                return self.fetchUserInfoUseCase.execute()
                    .asObservable()
            }
            .subscribe(onNext: {
                PreferenceManager.shared.setUserInfo(
                    ID: AES256.encrypt(string: $0.id),
                    platform: $0.platform,
                    profile: $0.profile,
                    displayName: AES256.encrypt(string: $0.displayName),
                    firstLoginTime: $0.first_login_time,
                    first: $0.first
                )
            }).disposed(by: disposeBag)
        
        return output
    }
}
