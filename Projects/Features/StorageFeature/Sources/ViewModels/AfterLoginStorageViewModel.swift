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

final public class AfterLoginViewModel:ViewModelType {
    
    
    

    var disposeBag = DisposeBag()
    var fetchUserInfoUseCase : FetchUserInfoUseCase!


    public struct Input {
        let textString:BehaviorRelay<String> = BehaviorRelay(value: "")
        
    }

    public struct Output {
        let isEditing:BehaviorRelay<Bool> = BehaviorRelay(value:false)
    }

    public init(
        fetchUserInfoUseCase:FetchUserInfoUseCase
    ) {
        
        self.fetchUserInfoUseCase = fetchUserInfoUseCase
        
        
        self.fetchUserInfoUseCase.execute(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjExNDgxMDA3NTUyNTM4MjA5NzcyNCIsImlhdCI6MTY3NjYxOTY2MSwiZXhwIjoxNjc3MjI0NDYxfQ.vrOCsbXaV4lgrp8ohUG9l2uI8mXHDmvY3Qb_jasnX18")
            .subscribe(onSuccess: {DEBUG_LOG($0)})
            .disposed(by: disposeBag)
        
        
        
        print("✅ AfterLoginViewModel 생성")
        

    }
    
    public func transform(from input: Input) -> Output {
        var output = Output()
        
        
        
        return output
    }
}
