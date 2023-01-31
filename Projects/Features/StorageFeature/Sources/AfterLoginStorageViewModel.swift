//
//  AfterLoginStorageViewModel.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/26.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay

final class AfterLoginStroageViewModel {

    let input = Input()
    let output = Output()
    var disposeBag = DisposeBag()

    struct Input {
        //let textString:BehaviorRelay<String> = BehaviorRelay(value: "")
        
    }

    struct Output {
        let isEditing:BehaviorRelay<Bool> = BehaviorRelay(value:false)
    }

    init() {
        
        print("✅ SearchViewModel 생성")
        

    }
}
