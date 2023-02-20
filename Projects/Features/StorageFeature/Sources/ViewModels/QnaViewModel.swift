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
        let categories:PublishSubject<[QnaCategoryEntity]> = PublishSubject()
    }

    public init(
        fetchQnaCategoriesUseCase: FetchQnaCategoriesUseCase,
        fetchQnaUseCase : FetchQnaUseCase
    ) {
        
        DEBUG_LOG("✅ \(Self.self) 생성")
        self.fetchQnaCategoriesUseCase = fetchQnaCategoriesUseCase
        self.fetchQnaUseCase = fetchQnaUseCase

    }
    
    public func transform(from input: Input) -> Output {
        let output = Output()
        
        fetchQnaCategoriesUseCase.execute()
            .filter({!$0.isEmpty})
            .map({
                var result:[QnaCategoryEntity] = [QnaCategoryEntity(category: "전체    ")]
                
                result += $0
                
                DEBUG_LOG(result)
                
                return result
            })
            .asObservable()
            .bind(to: output.categories)
            .disposed(by: disposeBag)
 
        return output
    }
}
