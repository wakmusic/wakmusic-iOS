//
//  BeforeSearchViewModel.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/01/09.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift


final class BeforeSearchViewModel {
    
    let input = Input()
    let output = Output()
    var disposeBag = DisposeBag()

    struct Input {
        
       
    }

    struct Output {
        var keywords:BehaviorRelay<[String]> = BehaviorRelay(value: ["우왁굳","아이네","고세구"])
    }
    
    
    
    
   
    
    
}
