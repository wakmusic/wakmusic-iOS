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

final public class QnaViewModel:ViewModelType {
    var disposeBag = DisposeBag()
    var fetchQnaCategoriesUseCase: FetchQnaCategoriesUseCase!
    var fetchQnaUseCase: FetchQnaUseCase!

    public struct Input {
    }

    public struct Output {
        let dataSource:BehaviorRelay<([QnaCategoryEntity], [QnaEntity])> = BehaviorRelay(value: ([], []))
    }

    public init(
        fetchQnaCategoriesUseCase: FetchQnaCategoriesUseCase,
        fetchQnaUseCase: FetchQnaUseCase
    ) {
        DEBUG_LOG("✅ \(Self.self) 생성")
        self.fetchQnaCategoriesUseCase = fetchQnaCategoriesUseCase
        self.fetchQnaUseCase = fetchQnaUseCase
    }
    
    public func transform(from input: Input) -> Output {
        let output = Output()
        
        let zip1 = fetchQnaCategoriesUseCase.execute().catchAndReturn([])
            .map({
                var result:[QnaCategoryEntity] = [QnaCategoryEntity(category: "전체    ")]

                result += $0
                    .map({
                    $0.category.count < 6 ?
                    QnaCategoryEntity(category: $0.category + String(repeating: " ", count: 6 - $0.category.count))  :
                    $0 })
                
                DEBUG_LOG(result)
                return result
            })
            .asObservable()
        
        let zip2 = fetchQnaUseCase.execute().catchAndReturn([])
            .asObservable()
        
        Observable.zip(zip1, zip2)
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)
        
        return output
    }
}
