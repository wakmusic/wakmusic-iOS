//
//  AfterLoginStorageViewModel.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/26.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import Utility
import RxSwift
import RxRelay
import DomainModule
import BaseFeature
import KeychainModule

final public class QnaContentViewModel:ViewModelType {

    var disposeBag = DisposeBag()
    
    var dataSource:[QnaEntity]
    

    public struct Input {
    
    }

    public struct Output {
        let dataSource:BehaviorRelay<[QnaEntity]> =  BehaviorRelay<[QnaEntity]>(value: [])

    }

    public init(
        dataSource:[QnaEntity]
    ) {
        
        DEBUG_LOG("✅ \(Self.self) 생성")
        self.dataSource = dataSource
     

    }
    
    public func transform(from input: Input) -> Output {
        let output = Output()
        
        
        return output
    }
}
