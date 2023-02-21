//
//  FavoriteViewModel.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/27.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

import Foundation
import RxSwift
import RxRelay
import BaseFeature

public final class MyPlayListViewModel:ViewModelType {
    
    

    let input = Input()
    let output = Output()
    var disposeBag = DisposeBag()

    public struct Input {
        let sourceIndexPath:BehaviorRelay<IndexPath> = BehaviorRelay(value: IndexPath(row: 0, section: 0))
        let destIndexPath:BehaviorRelay<IndexPath> = BehaviorRelay(value: IndexPath(row: 0, section: 0))
        
    }

    public struct Output {
        let isEditinglist:BehaviorRelay<Bool> = BehaviorRelay(value:false)
    }

    init() {
        
        print("✅ PlayListDetailViewModel 생성")
        
    }
    
    public func transform(from input: Input) -> Output {
        
        return Output()
        
    }
    
    
}
