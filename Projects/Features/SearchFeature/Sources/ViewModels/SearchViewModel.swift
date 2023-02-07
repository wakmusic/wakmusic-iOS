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
import DataModule
import BaseFeature

final class SearchViewModel:ViewModelType {
   
    

    let input = Input()
    let output = Output()
    var disposeBag = DisposeBag()

    struct Input {
        let textString:BehaviorRelay<String> = BehaviorRelay(value: "")
        
    }

    struct Output {
        let isFoucused:BehaviorRelay<Bool> = BehaviorRelay(value:false)
    }
    
    func transform(from input: Input) -> Output {
        //hello
        let output = Output()
        
        
        return output
    }

    init() {
        
        print("✅ SearchViewModel 생성")
        
        
        
        
    }
}
