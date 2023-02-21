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
import DataMappingModule
import Utility




public final class MultiPurposePopupViewModel:ViewModelType {
   
    
    let input = Input()
    let output = Output()
    
    var type:PurposeType!
 
    var createPlayListUseCase:CreatePlayListUseCase!
    var loadPlayListUseCase:LoadPlayListUseCase!
    var setUserNameUseCase:SetUserNameUseCase

    public struct Input {
        let textString:BehaviorRelay<String> = BehaviorRelay(value: "")
        
    }

    public struct Output {
        let isFoucused:BehaviorRelay<Bool> = BehaviorRelay(value:false)
    }

    public init(type:PurposeType,
                createPlayListUseCase:CreatePlayListUseCase,
                loadPlayListUseCase:LoadPlayListUseCase,
                setUserNameUseCase:SetUserNameUseCase) {
        

       
        print("✅ \(Self.self) 생성")
        self.type = type
        self.createPlayListUseCase = createPlayListUseCase
        self.loadPlayListUseCase = loadPlayListUseCase
        self.setUserNameUseCase = setUserNameUseCase
        
        
        
        
    }
    
    deinit{
        DEBUG_LOG("❌ \(Self.self) 소멸")
    }
    
    public func transform(from input: Input) -> Output {
        
        var output = Output()
        
        return output
    }
    
    
    
}
