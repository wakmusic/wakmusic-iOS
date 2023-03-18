//
//  HomeViewModel.swift
//  HomeFeature
//
//  Created by KTH on 2023/02/20.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import BaseFeature
import DomainModule
import Utility
import DataMappingModule

public final class HomeViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    var fetchChartRankingUseCase: FetchChartRankingUseCase
    var fetchNewSongUseCase: FetchNewSongUseCase
    var fetchRecommendPlayListUseCase: FetchRecommendPlayListUseCase

    public init(
        fetchChartRankingUseCase: any FetchChartRankingUseCase,
        fetchNewSongUseCase: any FetchNewSongUseCase,
        fetchRecommendPlayListUseCase: any FetchRecommendPlayListUseCase
    ){
        self.fetchChartRankingUseCase = fetchChartRankingUseCase
        self.fetchNewSongUseCase = fetchNewSongUseCase
        self.fetchRecommendPlayListUseCase = fetchRecommendPlayListUseCase
        DEBUG_LOG("✅ \(Self.self) 생성")
    }

    public struct Input {
        var newSongButtonTapped: PublishRelay<NewSongGroupType> = PublishRelay()
    }

    public struct Output {
        let dataSource: BehaviorRelay<[NewSongEntity]>
    }
    
    public func transform(from input: Input) -> Output {
     
        let dataSource: BehaviorRelay<[NewSongEntity]> = BehaviorRelay(value: [])
        
        self.fetchNewSongUseCase.execute(type: .all)
            .debug("fetchNewSongUseCase")
            .asObservable()
            .subscribe()
            .disposed(by: disposeBag)
        
        return Output(dataSource: dataSource)
    }
    
}
