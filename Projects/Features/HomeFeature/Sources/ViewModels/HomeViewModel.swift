//
//  HomeViewModel.swift
//  HomeFeature
//
//  Created by KTH on 2023/02/20.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import BaseFeature
import ChartDomainInterface
import Foundation
import PlayListDomainInterface
import RxCocoa
import RxSwift
import SongsDomainInterface
import Utility

public final class HomeViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    var fetchChartRankingUseCase: FetchChartRankingUseCase
    var fetchNewSongsUseCase: FetchNewSongsUseCase
    var fetchRecommendPlayListUseCase: FetchRecommendPlayListUseCase

    public init(
        fetchChartRankingUseCase: any FetchChartRankingUseCase,
        fetchNewSongsUseCase: any FetchNewSongsUseCase,
        fetchRecommendPlayListUseCase: any FetchRecommendPlayListUseCase
    ) {
        self.fetchChartRankingUseCase = fetchChartRankingUseCase
        self.fetchNewSongsUseCase = fetchNewSongsUseCase
        self.fetchRecommendPlayListUseCase = fetchRecommendPlayListUseCase
    }

    public struct Input {
        var chartMoreTapped: PublishSubject<Void> = PublishSubject()
        var chartAllListenTapped: PublishSubject<Void> = PublishSubject()
        var newSongsAllListenTapped: PublishSubject<Void> = PublishSubject()
        var refreshPulled: PublishSubject<Void> = PublishSubject()
    }

    public struct Output {
        var chartDataSource: BehaviorRelay<[ChartRankingEntity]>
        let newSongDataSource: BehaviorRelay<[NewSongsEntity]>
        var playListDataSource: BehaviorRelay<[RecommendPlayListEntity]>
    }

    public func transform(from input: Input) -> Output {
        let chartDataSource: BehaviorRelay<[ChartRankingEntity]> = BehaviorRelay(value: [])
        let newSongDataSource: BehaviorRelay<[NewSongsEntity]> = BehaviorRelay(value: [])
        let playListDataSource: BehaviorRelay<[RecommendPlayListEntity]> = BehaviorRelay(value: [])

        let chart = self.fetchChartRankingUseCase
            .execute(type: .hourly)
            .catchAndReturn(.init(updatedAt: "팬치들 미안해요 ㅠㅠ 잠시만 기다려주세요.", songs: []))
            .map { $0.songs }
            .asObservable()

        let newSongs = self.fetchNewSongsUseCase
            .execute(type: .all, page: 1, limit: 100)
            .catchAndReturn([])
            .asObservable()

        let playList = self.fetchRecommendPlayListUseCase
            .execute()
            .catchAndReturn([])
            .asObservable()

        let chartAndNewSong = Observable.zip(chart, newSongs)
        let firstLoad = Observable.zip(chartAndNewSong, playList)

        firstLoad
            .take(1)
            .subscribe(onNext: { arg, recommendPlayListEntity in
                let (chartRankingEntity, newSongEntity) = arg
                chartDataSource.accept(chartRankingEntity)
                newSongDataSource.accept(newSongEntity)
                playListDataSource.accept(recommendPlayListEntity)
            })
            .disposed(by: disposeBag)

        input.chartMoreTapped
            .map { _ in 1 }
            .subscribe(onNext: { index in
                NotificationCenter.default.post(name: .movedTab, object: index)
            }).disposed(by: disposeBag)

        input.chartAllListenTapped
            .withLatestFrom(chartDataSource)
            .subscribe(onNext: { songs in
                let songEntities: [SongEntity] = songs.map {
                    return SongEntity(
                        id: $0.id,
                        title: $0.title,
                        artist: $0.artist,
                        remix: "",
                        reaction: "",
                        views: $0.views,
                        last: $0.last,
                        date: $0.date
                    )
                }
                PlayState.shared.loadAndAppendSongsToPlaylist(songEntities)
            })
            .disposed(by: disposeBag)

        input.newSongsAllListenTapped
            .withLatestFrom(newSongDataSource)
            .subscribe(onNext: { newSongs in
                let songEntities: [SongEntity] = newSongs.map {
                    return SongEntity(
                        id: $0.id,
                        title: $0.title,
                        artist: $0.artist,
                        remix: $0.remix,
                        reaction: $0.reaction,
                        views: $0.views,
                        last: $0.last,
                        date: "\($0.date)"
                    )
                }
                PlayState.shared.loadAndAppendSongsToPlaylist(songEntities)
            })
            .disposed(by: disposeBag)

        input.refreshPulled
            .flatMap { _ -> Observable<(([ChartRankingEntity], [NewSongsEntity]), [RecommendPlayListEntity])> in
                let chartAndNewSong = Observable.zip(chart, newSongs)
                let result = Observable.zip(chartAndNewSong, playList)
                return result
            }
            .debug("✅ Refresh Completed")
            .subscribe(onNext: { arg, recommendPlayListEntity in
                let (chartRankingEntity, newSongEntity) = arg
                chartDataSource.accept(chartRankingEntity)
                newSongDataSource.accept(newSongEntity)
                playListDataSource.accept(recommendPlayListEntity)
            })
            .disposed(by: disposeBag)

        return Output(
            chartDataSource: chartDataSource,
            newSongDataSource: newSongDataSource,
            playListDataSource: playListDataSource
        )
    }
}
