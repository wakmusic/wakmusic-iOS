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
        let statusCode:PublishSubject<String> = PublishSubject()
    }

    public init(
        withDrawUserInfoUseCase:WithdrawUserInfoUseCase
    ) {
        
        self.withDrawUserInfoUseCase = withDrawUserInfoUseCase
        
  
        print("✅ RequestViewModel 생성")
        
        
        
       
        

    }
    
    public func transform(from input: Input) -> Output {
        var output = Output()
        
     
        input.pressWithdraw
            .take(1)
            .flatMap({[weak self] () -> Completable  in
            
            guard let self = self else {
                return Completable.empty()
            }
            
                return self.withDrawUserInfoUseCase.execute(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjAwMDU5Ny4wMGIyMWU3MWM2MmU0M2U2YmQ4MTQ3NmRjOTcxYmEyMi4wNzUyIiwiaWF0IjoxNjc2NjM4ODIwLCJleHAiOjE2NzcyNDM2MjB9.FgTlHG0ZeerkAvgTb78_QLeHbZFpZz8TdedekHq4TXo")
        })
        .debug("TTT")
        .subscribe(onError: { (error:Error) in
            
                    let error = error.asWMError
                    DEBUG_LOG(error.errorDescription!)
                    output.statusCode.onNext(error.errorDescription!)
        },onCompleted: {
            DEBUG_LOG("성공성공성공")
            output.statusCode.onNext("")
        }).disposed(by: disposeBag)
        

        
        
        return output
    }
}

