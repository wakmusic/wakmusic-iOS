//
//  SearchViewModel.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/01/05.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import BaseFeature
import DomainModule
import Utility

public  final class LoginViewModel:ViewModelType {
   
    

    let input = Input()
    let output = Output()
    
    var fetchTokenUseCase: FetchTokenUseCase!
    var disposeBag = DisposeBag()
    
    
    public init(fetchTokenUseCase:FetchTokenUseCase){
        
        self.fetchTokenUseCase = fetchTokenUseCase
        print("✅ LoginViewModel 생성")
        
        
        fetchTokenUseCase.execute(id: "114810075525382097724", type: .google)
            .subscribe(onSuccess: {DEBUG_LOG($0)})
            .disposed(by: disposeBag)
      
    }

    public struct Input {
    
        
    }

    public struct Output {
       
    }
    
    public func transform(from input: Input) -> Output {
        //hello
        let output = Output()
        
        
        return output
    }

}
