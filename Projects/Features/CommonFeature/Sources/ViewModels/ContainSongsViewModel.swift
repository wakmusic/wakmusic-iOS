//
//  ContainSongsViewModel.swift
//  CommonFeature
//
//  Created by yongbeomkwak on 2023/03/11.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import BaseFeature
import RxRelay
import DomainModule
import RxSwift

public final class ContainSongsViewModel:ViewModelType {

    
    public struct Input {
        
        let newPlayTap:PublishSubject<Void> = PublishSubject()
        
    }
    
    public struct Output{
        let dataSource: BehaviorRelay<[PlayListEntity]> = BehaviorRelay(value: [])
    }
    
    public func transform(from input: Input) -> Output {
        
        let output = Output()
        
        
        
        return output
    }
    
    
}
