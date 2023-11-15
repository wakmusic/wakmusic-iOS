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
    var fetchNewSongsUseCase: FetchNewSongsUseCase
    var fetchRecommendPlayListUseCase: FetchRecommendPlayListUseCase

    public init(
        fetchChartRankingUseCase: any FetchChartRankingUseCase,
        fetchNewSongsUseCase: any FetchNewSongsUseCase,
        fetchRecommendPlayListUseCase: any FetchRecommendPlayListUseCase
    ){
        self.fetchChartRankingUseCase = fetchChartRankingUseCase
        self.fetchNewSongsUseCase = fetchNewSongsUseCase
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
        let newSongDataSource: BehaviorRelay<[NewSongsEntity]>
        var playListDataSource: BehaviorRelay<[RecommendPlayListEntity]>
        var songEntityOfAllChart: PublishSubject<[ChartRankingEntity]>
    }
    
    public func transform(from input: Input) -> Output {
        let chartDataSource: BehaviorRelay<[ChartRankingEntity]> = BehaviorRelay(value: [])
        let newSongDataSource: BehaviorRelay<[NewSongsEntity]> = BehaviorRelay(value: [])
        let playListDataSource: BehaviorRelay<[RecommendPlayListEntity]> = BehaviorRelay(value: [])
        let songEntityOfAllChart: PublishSubject<[ChartRankingEntity]> = PublishSubject()
        
        let limit: Int = 10
        let chartAndNewSong = Observable.zip(
            self.fetchChartRankingUseCase
                .execute(type: .hourly, limit: 100)
                .catchAndReturn([])
                .asObservable(),
            self.fetchNewSongsUseCase
                .execute(type: .all, page: 1, limit: limit)
                .catchAndReturn([])
                .asObservable()
        )
        
        let firstLoad = Observable.zip(
            chartAndNewSong,
            self.fetchRecommendPlayListUseCase
                .execute()
                .catchAndReturn([])
                .asObservable()
        )

        firstLoad
            .take(1)
            .subscribe(onNext: { (arg, recommendPlayListEntity) in
                let (chartRankingEntity, newSongEntity) = arg
                chartDataSource.accept(chartRankingEntity)
                newSongDataSource.accept(newSongEntity)
                playListDataSource.accept(recommendPlayListEntity)
            }).disposed(by: disposeBag)

        input.chartMoreTapped
            .map { _ in 1 }
            .subscribe(onNext: { (index) in
                NotificationCenter.default.post(name: .movedTab, object: index)
            }).disposed(by: disposeBag)
        
        input.allListenTapped
            .withLatestFrom(chartDataSource)
            .bind(to: songEntityOfAllChart)
            .disposed(by: disposeBag)

        input.newSongTypeTapped
            .skip(1)
            .debug("✅ newSongTypeTapped")
            .flatMap { [weak self] (type) -> Observable<[NewSongsEntity]> in
                guard let `self` = self else { return Observable.empty() }
                return self.fetchNewSongsUseCase.execute(type: type, page: 1, limit: limit)
                    .catchAndReturn([])
                    .asObservable()
            }
            .bind(to: newSongDataSource)
            .disposed(by: disposeBag)
        
        input.refreshPulled
            .withLatestFrom(input.newSongTypeTapped)
            .flatMap { [weak self] (type) -> Observable<(([ChartRankingEntity], [NewSongsEntity]), [RecommendPlayListEntity])> in
                guard let self = self else{ return Observable.empty() }
                
                let chartAndNewSong = Observable.zip(
                    self.fetchChartRankingUseCase
                        .execute(type: .hourly, limit: 100)
                        .catchAndReturn([])
                        .asObservable(),
                    self.fetchNewSongsUseCase
                        .execute(type: type, page: 1, limit: limit)
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
            songEntityOfAllChart: songEntityOfAllChart
        )
    }
}
