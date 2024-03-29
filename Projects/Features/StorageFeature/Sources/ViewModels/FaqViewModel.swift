//
//  AfterLoginStorageViewModel.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/26.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import BaseFeature
import FaqDomainInterface
import Foundation
import KeychainModule
import RxRelay
import RxSwift
import Utility

public final class FaqViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    var fetchFaqCategoriesUseCase: FetchFaqCategoriesUseCase!
    var fetchQnaUseCase: FetchFaqUseCase!

    public struct Input {}

    public struct Output {
        let dataSource: BehaviorRelay<([String], [FaqEntity])> = BehaviorRelay(value: ([], []))
    }

    public init(
        fetchFaqCategoriesUseCase: FetchFaqCategoriesUseCase,
        fetchQnaUseCase: FetchFaqUseCase
    ) {
        DEBUG_LOG("✅ \(Self.self) 생성")
        self.fetchFaqCategoriesUseCase = fetchFaqCategoriesUseCase
        self.fetchQnaUseCase = fetchQnaUseCase
    }

    public func transform(from input: Input) -> Output {
        let output = Output()

        let zip1 = fetchFaqCategoriesUseCase.execute()
            .catchAndReturn(FaqCategoryEntity(categories: []))
            .map {
                var result: [String] = [String("전체    ")]

                result += $0.categories.map { $0.count < 6 ? $0 + String(repeating: " ", count: 6 - $0.count) : $0 }

                DEBUG_LOG(result)
                return result
            }
            .asObservable()

        let zip2 = fetchQnaUseCase.execute()
            .catchAndReturn([])
            .asObservable()

        Observable.zip(zip1, zip2)
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)

        return output
    }
}
