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

public  final class SearchViewModel:ViewModelType {
   
    

    let input = Input()
    let output = Output()
    var disposeBag = DisposeBag()
    
    public init(){
        
        DEBUG_LOG("✅ \(Self.self) 생성")
        
      
    }

    public struct Input {
        let textString:BehaviorRelay<String> = BehaviorRelay(value: "")
        
    }

    public struct Output {
        let isFoucused:BehaviorRelay<Bool> = BehaviorRelay(value:false)
    }
    
    public func transform(from input: Input) -> Output {
        //hello
        let output = Output()
        
        
        return output
    }

}
