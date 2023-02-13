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



public final class AfterSearchViewModel:ViewModelType {
   
    

    let input = Input()
    let output = Output()
    
    var disposeBag = DisposeBag()

    
    public init(){
        
        print("✅ AfterSearchViewModel 생성")
        
    
    }

    public struct Input {
        let text:BehaviorRelay<String> = BehaviorRelay<String>(value: "")
        
    }

    public struct Output {
        
    }
    
    public func transform(from input: Input) -> Output {
        //hello
        let output = Output()
        
        
        return output
    }

}
