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

public enum PlayListType{
    case custom
    case wmRecommend
}

public final class PlayListDetailViewModel:ViewModelType {
   

    let input = Input()
    let output = Output()
    var type:PlayListType!
    var fetchRecommendPlayListDetailUseCase:FetchRecommendPlayListDetailUseCase!
    var disposeBag = DisposeBag()

    public struct Input {
        let textString:BehaviorRelay<String> = BehaviorRelay(value: "")
        let sourceIndexPath:BehaviorRelay<IndexPath> = BehaviorRelay(value: IndexPath(row: 0, section: 0))
        let destIndexPath:BehaviorRelay<IndexPath> = BehaviorRelay(value: IndexPath(row: 0, section: 0))
        
        
    }

    public struct Output {
        let isEditinglist:BehaviorRelay<Bool> = BehaviorRelay(value:false)
    }

    public init(type:PlayListType,fetchRecommendPlayListDetailUseCase:FetchRecommendPlayListDetailUseCase) {
        
        self.type = type
        self.fetchRecommendPlayListDetailUseCase = fetchRecommendPlayListDetailUseCase
        
        print("✅ PlayListDetailViewModel 생성")
        
    }
    
    public func transform(from input: Input) -> Output {
        
        return output
    }
    
    
    
}
