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
import Utility

public final class BeforeSearchContentViewModel:ViewModelType {
  
    

    let input = Input()

    var disposeBag = DisposeBag()
    
    var fetchRecommendPlayListUseCase: FetchRecommendPlayListUseCase

    public init(
        fetchRecommendPlayListUseCase: any FetchRecommendPlayListUseCase
    ){
        self.fetchRecommendPlayListUseCase = fetchRecommendPlayListUseCase
        DEBUG_LOG("✅ BeforeSearchContentViewModel 생성")
    }
    
    
    public struct Input {
        
        
    }

    public struct Output {
        let showRecommend:BehaviorRelay<Bool>
        let dataSource:BehaviorRelay<[RecommendPlayListEntity]>
    }

    
    public func transform(from input: Input) -> Output {
        
        let dataSource:BehaviorRelay<[RecommendPlayListEntity]> = BehaviorRelay(value: [])
        let showRecommend:BehaviorRelay<Bool> = BehaviorRelay(value:true)
        
        fetchRecommendPlayListUseCase
            .execute()
            .catchAndReturn([])
            .asObservable()
            .map({ (model) -> [RecommendPlayListEntity] in
                return model
            })
            .bind(to: dataSource)
            .disposed(by: disposeBag)
    
        
        return Output(showRecommend: showRecommend, dataSource: dataSource)
    }
}
