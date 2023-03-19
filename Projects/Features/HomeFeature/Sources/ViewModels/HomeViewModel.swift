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
        var newSongTypeTapped: BehaviorSubject<NewSongGroupType> = BehaviorSubject(value: .all)
        var chartMoreTapped: PublishSubject<Void> = PublishSubject()
        var allListenTapped: PublishSubject<Void> = PublishSubject()
        var refreshPulled: PublishSubject<Void> = PublishSubject()
    }

    public struct Output {
        var chartDataSource: BehaviorRelay<[ChartRankingEntity]>
        let newSongDataSource: BehaviorRelay<[NewSongEntity]>
        var playListDataSource: BehaviorRelay<[RecommendPlayListEntity]>
        var idOfAllChart: PublishSubject<[String]>
    }
    
    public func transform(from input: Input) -> Output {
     
        let chartDataSource: BehaviorRelay<[ChartRankingEntity]> = BehaviorRelay(value: [])
        let newSongDataSource: BehaviorRelay<[NewSongEntity]> = BehaviorRelay(value: [])
        let playListDataSource: BehaviorRelay<[RecommendPlayListEntity]> = BehaviorRelay(value: [])
        let idOfAllChart: PublishSubject<[String]> = PublishSubject()

        fetchChartRankingUseCase
            .execute(type: .hourly, limit: 100)
            .catchAndReturn([])
            .asObservable()
            .bind(to: chartDataSource)
            .disposed(by: disposeBag)

        fetchNewSongUseCase
            .execute(type: .all)
            .catchAndReturn([])
            .asObservable()
            .bind(to: newSongDataSource)
            .disposed(by: disposeBag)
        
        fetchRecommendPlayListUseCase
            .execute()
            .catchAndReturn([])
            .asObservable()
            .bind(to: playListDataSource)
            .disposed(by: disposeBag)
        
        input.chartMoreTapped
            .map { _ in 1 }
            .subscribe(onNext: { (index) in
                NotificationCenter.default.post(name: .movedTab, object: index)
            }).disposed(by: disposeBag)
        
        input.allListenTapped
            .withLatestFrom(chartDataSource)
            .map { $0.map { $0.id }}
            .bind(to: idOfAllChart)
            .disposed(by: disposeBag)

        input.newSongTypeTapped
            .skip(1)
            .debug("✅ newSongTypeTapped")
            .flatMap { [weak self] (type) -> Observable<[NewSongEntity]> in
                guard let `self` = self else { return Observable.empty() }
                return self.fetchNewSongUseCase.execute(type: type)
                    .catchAndReturn([])
                    .asObservable()
            }
            .bind(to: newSongDataSource)
            .disposed(by: disposeBag)
        
        input.refreshPulled
            .withLatestFrom(input.newSongTypeTapped)
            .flatMap { [weak self] (type) -> Observable<(([ChartRankingEntity], [NewSongEntity]), [RecommendPlayListEntity])> in
                guard let self = self else{ return Observable.empty() }
                
                let chartAndNewSong = Observable.zip(
                    self.fetchChartRankingUseCase
                        .execute(type: .hourly, limit: 100)
                        .catchAndReturn([])
                        .asObservable(),
                    self.fetchNewSongUseCase
                        .execute(type: type)
                        .catchAndReturn([])
                        .asObservable()
                )
                let result = Observable.zip(
                    chartAndNewSong,
                    self.fetchRecommendPlayListUseCase
                        .execute()
                        .catchAndReturn([])
                        .asObservable()
                )
                return result
            }
            .debug("✅ Refresh Completed")
            .subscribe(onNext: { (arg, recommendPlayListEntity) in
                let (chartRankingEntity, newSongEntity) = arg
                chartDataSource.accept(chartRankingEntity)
                newSongDataSource.accept(newSongEntity)
                playListDataSource.accept(recommendPlayListEntity)
            }).disposed(by: disposeBag)

        return Output(
            chartDataSource: chartDataSource,
            newSongDataSource: newSongDataSource,
            playListDataSource: playListDataSource,
            idOfAllChart: idOfAllChart
        )
    }
}
