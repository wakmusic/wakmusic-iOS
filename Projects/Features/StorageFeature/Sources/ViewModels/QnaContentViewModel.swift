//
//  AfterLoginStorageViewModel.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/26.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import BaseFeature
import Foundation
import KeychainModule
import RxRelay
import RxSwift
import Utility
import FaqDomainInterface

public final class QnaContentViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    var dataSource: [FaqEntity]

    public struct Input {}

    public struct Output {}

    public init(
        dataSource: [FaqEntity]
    ) {
        DEBUG_LOG("✅ \(Self.self) 생성")
        self.dataSource = dataSource
    }

    public func transform(from input: Input) -> Output {
        let output = Output()
        return output
    }
}
