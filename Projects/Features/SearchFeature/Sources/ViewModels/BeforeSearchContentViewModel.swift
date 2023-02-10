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
    let output = Output()
    var disposeBag = DisposeBag()
    
    var fetchRecommendPlayListUseCase: FetchRecommendPlayListUseCase

    public init(
        fetchRecommendPlayListUseCase: any FetchRecommendPlayListUseCase
    ){
        self.fetchRecommendPlayListUseCase = fetchRecommendPlayListUseCase
        print("✅ BeforeSearchContentViewModel 생성")
        
        
        fetchRecommendPlayListUseCase.execute().subscribe(onSuccess: {
            DEBUG_LOG($0)
        }).disposed(by: disposeBag)
    }
    
    
    public struct Input {
        
        
    }

    public struct Output {
        let showRecommend:BehaviorRelay<Bool> = BehaviorRelay(value:false)
    }

    
    public func transform(from input: Input) -> Output {
        let output = Output()
        
        return output
    }
}
