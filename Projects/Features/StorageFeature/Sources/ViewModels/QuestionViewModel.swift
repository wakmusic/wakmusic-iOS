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

public final class QuestionViewModel:ViewModelType {

    var disposeBag = DisposeBag()
    
    

    public struct Input {
    
    
    }

    public struct Output {
        
        var selectedIndex:PublishRelay<Int> = PublishRelay()
    
    }

    public init(

    ) {
        
        DEBUG_LOG("✅ \(Self.self) 생성")
     
    }
    
    deinit {
        DEBUG_LOG("❌ \(Self.self) 소멸")
    }
    
    public func transform(from input: Input) -> Output {
        let output = Output()
        
        
        
        return output
    }
}
