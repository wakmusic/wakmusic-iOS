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
        var chartRanking: BehaviorRelay<[ChartRankingEntity]>
        let newSong: BehaviorRelay<[NewSongEntity]>
        var recommendPlayList: BehaviorRelay<[RecommendPlayListEntity]>
    }
    
    public func transform(from input: Input) -> Output {
     
        let chartRanking: BehaviorRelay<[ChartRankingEntity]> = BehaviorRelay(value: [])
        let newSong: BehaviorRelay<[NewSongEntity]> = BehaviorRelay(value: [])
        let recommendPlayList: BehaviorRelay<[RecommendPlayListEntity]> = BehaviorRelay(value: [])

        self.fetchChartRankingUseCase.execute(type: .total, limit: 5)
            .catchAndReturn([])
            .asObservable()
            .map({ (model) -> [ChartRankingEntity] in
                return model
            })
            .bind(to: chartRanking)
            .disposed(by: disposeBag)

        self.fetchNewSongUseCase.execute(type: .all)
            .catchAndReturn([])
            .asObservable()
            .map({ (model) -> [NewSongEntity] in
                return model
            })
            .bind(to: newSong)
            .disposed(by: disposeBag)

        self.fetchRecommendPlayListUseCase.execute()
            .catchAndReturn([])
            .asObservable()
            .map({ (model) -> [RecommendPlayListEntity] in
                return model
            })
            .bind(to: recommendPlayList)
            .disposed(by: disposeBag)
        
        return Output(
            chartRanking: chartRanking,
            newSong: newSong,
            recommendPlayList: recommendPlayList
        )
    }
    
}
