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

public final class WakMusicFeedbackViewModel:ViewModelType {

    var disposeBag = DisposeBag()
    var inquiryWeeklyChartUseCase: InquiryWeeklyChartUseCase
    
    public struct Input {
        var textString:PublishRelay<String> = PublishRelay()
    }

    public struct Output {
    }

    public init(
        inquiryWeeklyChartUseCase: InquiryWeeklyChartUseCase
    ) {
        self.inquiryWeeklyChartUseCase = inquiryWeeklyChartUseCase
    }
    
    deinit {
        DEBUG_LOG("❌ \(Self.self) 소멸")
    }
    
    public func transform(from input: Input) -> Output {
        let output = Output()
        return output
    }
}
