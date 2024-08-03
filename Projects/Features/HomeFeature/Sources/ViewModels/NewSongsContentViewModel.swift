//
//  NewSongsContentViewModel.swift
//  CommonFeature
//
//  Created by KTH on 2023/11/15.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import BaseFeature
import ChartDomainInterface
import Foundation
import LogManager
import RxRelay
import RxSwift
import SongsDomainInterface
import Utility

public final class NewSongsContentViewModel: ViewModelType {
    public let type: NewSongGroupType
    private let disposeBag = DisposeBag()
    private let fetchNewSongsUseCase: FetchNewSongsUseCase

    deinit { DEBUG_LOG("❌ \(Self.self) Deinit") }

    public init(
        type: NewSongGroupType,
        fetchNewSongsUseCase: FetchNewSongsUseCase
    ) {
        self.type = type
        self.fetchNewSongsUseCase = fetchNewSongsUseCase
    }

    public struct Input {
        let pageID: BehaviorRelay<Int> = BehaviorRelay(value: 1)
        let songTapped: PublishSubject<Int> = PublishSubject()
        let allSongSelected: PublishSubject<Bool> = PublishSubject()
        let groupPlayTapped: PublishSubject<PlayEvent> = PublishSubject()
        let refreshPulled: PublishSubject<Void> = PublishSubject()
    }

    public struct Output {
        let dataSource: BehaviorRelay<[NewSongsEntity]> = BehaviorRelay(value: [])
        let indexOfSelectedSongs: BehaviorRelay<[Int]> = BehaviorRelay(value: [])
        let songEntityOfSelectedSongs: BehaviorRelay<[SongEntity]> = BehaviorRelay(value: [])
        let canLoadMore: BehaviorRelay<Bool> = BehaviorRelay(value: true)
        let showToast: PublishSubject<String> = .init()
        let showLogin: PublishSubject<Void> = .init()
    }

    public func transform(from input: Input) -> Output {
        let output = Output()

        let refresh = Observable.combineLatest(
            output.dataSource,
            input.pageID
        ) { dataSource, pageID -> [NewSongsEntity] in
            return pageID == 1 ? [] : dataSource
        }

        let type: NewSongGroupType = self.type
        let fetchNewSongsUseCase = self.fetchNewSongsUseCase
        let limit: Int = 30

        input.pageID
            .flatMap { pageID -> Single<[NewSongsEntity]> in
                return fetchNewSongsUseCase
                    .execute(type: type, page: pageID, limit: limit)
                    .catchAndReturn([])
            }
            .asObservable()
            .do(onNext: { model in
                let canLoadMore: Bool = model.count < limit ? false : true
                output.canLoadMore.accept(canLoadMore)
                LogManager
                    .printDebug(
                        "page: \(input.pageID.value) called, count: \(model.count), nextPage exist: \(canLoadMore)"
                    )
            }, onError: { _ in
                output.canLoadMore.accept(false)
            })
            .withLatestFrom(refresh, resultSelector: { newModels, datasources -> [NewSongsEntity] in
                return datasources + newModels
            })
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)

        input.refreshPulled
            .map { _ in 1 }
            .bind(to: input.pageID)
            .disposed(by: disposeBag)

        input.songTapped
            .withLatestFrom(output.indexOfSelectedSongs, resultSelector: { index, selectedSongs -> [Int] in
                if selectedSongs.contains(index) {
                    guard let removeTargetIndex = selectedSongs.firstIndex(where: { $0 == index })
                    else { return selectedSongs }
                    var newSelectedSongs = selectedSongs
                    newSelectedSongs.remove(at: removeTargetIndex)
                    return newSelectedSongs
                } else {
                    return selectedSongs + [index]
                }
            })
            .map { $0.sorted { $0 < $1 } }
            .bind(to: output.indexOfSelectedSongs)
            .disposed(by: disposeBag)

        input.allSongSelected
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .map { flag, dataSource -> [Int] in
                return flag ? Array(0 ..< dataSource.count) : []
            }
            .bind(to: output.indexOfSelectedSongs)
            .disposed(by: disposeBag)

        Utility.PreferenceManager.$startPage
            .skip(1)
            .map { _ in [] }
            .bind(to: output.indexOfSelectedSongs)
            .disposed(by: disposeBag)

        output.indexOfSelectedSongs
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .map { selectedSongs, dataSource in
                var newModel = dataSource
                newModel.indices.forEach { newModel[$0].isSelected = false }
                selectedSongs.forEach { i in
                    newModel[i].isSelected = true
                }
                return newModel
            }
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)

        output.indexOfSelectedSongs
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .map { indexOfSelectedSongs, dataSource -> [SongEntity] in
                return indexOfSelectedSongs.map {
                    SongEntity(
                        id: dataSource[$0].id,
                        title: dataSource[$0].title,
                        artist: dataSource[$0].artist,
                        views: dataSource[$0].views,
                        date: "\(dataSource[$0].date)"
                    )
                }
            }
            .bind(to: output.songEntityOfSelectedSongs)
            .disposed(by: disposeBag)

        input.groupPlayTapped
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .map { type, dataSource -> (PlayEvent, [SongEntity]) in
                let songEntities: [SongEntity] = dataSource.map {
                    return SongEntity(
                        id: $0.id,
                        title: $0.title,
                        artist: $0.artist,
                        views: $0.views,
                        date: "\($0.date)"
                    )
                }
                return (type, songEntities)
            }
            .map { type, dataSource -> [SongEntity] in
                switch type {
                case .allPlay:
                    return dataSource
                case .shufflePlay:
                    return dataSource.shuffled()
                }
            }
            .subscribe(onNext: { songs in
                PlayState.shared.loadAndAppendSongsToPlaylist(songs)
            })
            .disposed(by: disposeBag)

        return output
    }
}
