//
//  ProfilePopViewModel.swift
//  CommonFeature
//
//  Created by KTH on 2023/02/18.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import BaseFeature
import DomainModule
import DataMappingModule
import Utility

public final class ProfilePopViewModel {
    
    let input = Input()
    let output = Output()
    var disposeBag = DisposeBag()
    var setProfileUseCase: SetProfileUseCase
    var fetchUserInfoUseCase: FetchUserInfoUseCase
    
    public struct Input {
        var setProfileRequest: PublishSubject<FanType> = PublishSubject()
    }

    public struct Output {
        var resultDescription: PublishSubject<String> = PublishSubject()
    }
    
    public init(
        setProfileUseCase: any SetProfileUseCase,
        fetchUserInfoUseCase: any FetchUserInfoUseCase
    ){
        self.setProfileUseCase = setProfileUseCase
        self.fetchUserInfoUseCase = fetchUserInfoUseCase
        
        input.setProfileRequest
            .flatMap { [weak self] (fanType) -> Observable<BaseEntity> in
                guard let self = self else { return Observable.empty() }
                return self.setProfileUseCase.execute(image: fanType.rawValue)
                    .asObservable()
            }
            .withLatestFrom(input.setProfileRequest) { ($0, $1) }
            .subscribe(onNext: { [weak self] (model, fanType) in
                guard let self = self, model.status == 200 else { return }
                Utility.PreferenceManager.userInfo = Utility.PreferenceManager.userInfo?.update(profile: fanType.rawValue)
                self.output.resultDescription.onNext("")

            }, onError: { [weak self] (error) in
                guard let self = self else { return }
                self.output.resultDescription.onNext(error.asWMError.errorDescription ?? "")
            })
            .disposed(by: disposeBag)
        
    }
}
