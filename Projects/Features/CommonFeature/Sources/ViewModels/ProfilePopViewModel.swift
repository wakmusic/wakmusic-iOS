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
    
    var fetchProfileListUseCase: FetchProfileListUseCase
    var setProfileUseCase: SetProfileUseCase
    
    public struct Input {
        var setProfileRequest: PublishSubject<String> = PublishSubject()
    }

    public struct Output {
        var resultDescription: PublishSubject<String> = PublishSubject()
        var dataSource: BehaviorRelay<[ProfileListEntity]> = BehaviorRelay(value: [])
    }
    
    public init(
        fetchProfileListUseCase: any FetchProfileListUseCase,
        setProfileUseCase: any SetProfileUseCase
    ){
        self.fetchProfileListUseCase = fetchProfileListUseCase
        self.setProfileUseCase = setProfileUseCase
        
        fetchProfileListUseCase.execute()
            .asObservable()
            .catchAndReturn([])
            .debug("fetchProfileListUseCase")
            .map({ (model) -> [ProfileListEntity] in
                let currentProfile = Utility.PreferenceManager.userInfo?.profile ?? "unknown"
                
                var newModel = model
                newModel.indices.forEach { newModel[$0].isSelected = (currentProfile == newModel[$0].id) }                
                return newModel
            })
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)
        
        input.setProfileRequest
            .flatMap { [weak self] (id) -> Observable<BaseEntity> in
                guard let self = self else { return Observable.empty() }
                return self.setProfileUseCase.execute(image: id)
                    .asObservable()
            }
            .withLatestFrom(input.setProfileRequest) { ($0, $1) }
            .subscribe(onNext: { [weak self] (model, id) in
                guard let self = self, model.status == 200 else { return }
                Utility.PreferenceManager.userInfo = Utility.PreferenceManager.userInfo?.update(profile: id)
                self.output.resultDescription.onNext("")

            }, onError: { [weak self] (error) in
                guard let self = self else { return }
                self.output.resultDescription.onNext(error.asWMError.errorDescription ?? "")
            })
            .disposed(by: disposeBag)
        
    }
}
