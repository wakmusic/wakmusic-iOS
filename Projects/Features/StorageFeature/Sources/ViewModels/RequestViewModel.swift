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

final public class RequestViewModel:ViewModelType {
    
    
    

    var disposeBag = DisposeBag()
    var withDrawUserInfoUseCase: WithdrawUserInfoUseCase


    public struct Input {
        let pressWithdraw:PublishSubject<Void> = PublishSubject()
        
        
    }

    public struct Output {
        
    }

    public init(
        withDrawUserInfoUseCase:WithdrawUserInfoUseCase
    ) {
        
        self.withDrawUserInfoUseCase = withDrawUserInfoUseCase
        
      
        
        
        
        print("✅ RequestViewModel 생성")
        

    }
    
    public func transform(from input: Input) -> Output {
        var output = Output()
        
        
        
        return output
    }
}
