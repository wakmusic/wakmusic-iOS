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

public final class SuggestFunctionViewModel:ViewModelType {

    var disposeBag = DisposeBag()
    var suggestFunctionUseCase: SuggestFunctionUseCase

    public struct Input {
        var textString:PublishRelay<String> = PublishRelay()
    }

    public struct Output {
        var selectedIndex:BehaviorRelay<Int> = BehaviorRelay(value: -2)
    }

    public init(
        suggestFunctionUseCase: SuggestFunctionUseCase
    ) {
        self.suggestFunctionUseCase = suggestFunctionUseCase
    }
    
    deinit {
        DEBUG_LOG("❌ \(Self.self) 소멸")
    }
    
    public func transform(from input: Input) -> Output {
        let output = Output()
        return output
    }
}
