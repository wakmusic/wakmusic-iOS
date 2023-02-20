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
import KeychainModule

final public class QnaViewModel:ViewModelType {

    var disposeBag = DisposeBag()
    
    var fetchQnaCategoriesUseCase: FetchQnaCategoriesUseCase
    

    public struct Input {
    
    }

    public struct Output {
        
    }

    public init(
        fetchQnaCategoriesUseCase: FetchQnaCategoriesUseCase
    ) {
        
        DEBUG_LOG("✅ \(Self.self) 생성")
        self.fetchQnaCategoriesUseCase = fetchQnaCategoriesUseCase
        
        
        
        fetchQnaCategoriesUseCase.execute()
            .subscribe { 
                DEBUG_LOG($0)
            }.disposed(by: disposeBag)
    }
    
    public func transform(from input: Input) -> Output {
        let output = Output()
 
        return output
    }
}
