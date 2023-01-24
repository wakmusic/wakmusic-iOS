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

final class PlayListDetailViewModel {

    let input = Input()
    let output = Output()
    var disposeBag = DisposeBag()

    struct Input {
        let textString:BehaviorRelay<String> = BehaviorRelay(value: "")
        let sourceIndexPath:BehaviorRelay<IndexPath> = BehaviorRelay(value: IndexPath(row: 0, section: 0))
        let destIndexPath:BehaviorRelay<IndexPath> = BehaviorRelay(value: IndexPath(row: 0, section: 0))
        
    }

    struct Output {
        let isEditinglist:BehaviorRelay<Bool> = BehaviorRelay(value:false)
    }

    init() {
        
        print("✅ PlayListDetailViewModel 생성")
        
    }
    
    
}
