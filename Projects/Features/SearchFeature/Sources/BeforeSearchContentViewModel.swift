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

final class BeforeSearchContentViewModel {

    let input = Input()
    let output = Output()
    var disposeBag = DisposeBag()

    struct Input {
        
        
    }

    struct Output {
        let showRecommand:BehaviorRelay<Bool> = BehaviorRelay(value:false)
    }

    init() {
        
        print("✅ SearchViewModel 생성")
        

    }
}
