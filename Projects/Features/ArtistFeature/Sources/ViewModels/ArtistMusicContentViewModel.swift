//
//  ArtistMusicContentViewModel.swift
//  ArtistFeature
//
//  Created by KTH on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import ArtistDomainInterface
import BaseFeature
import SongsDomainInterface
import Foundation
import RxCocoa
import RxSwift
import Utility

public final class ArtistMusicContentViewModel: ViewModelType {
    var fetchArtistSongListUseCase: FetchArtistSongListUseCase
    var type: ArtistSongSortType
    var model: ArtistListEntity?
    var disposeBag = DisposeBag()

    public init(
        type: ArtistSongSortType,
        model: ArtistListEntity?,
        fetchArtistSongListUseCase: any FetchArtistSongListUseCase
    ) {
        self.type = type
        self.model = model
        self.fetchArtistSongListUseCase = fetchArtistSongListUseCase
    }

    public struct Input {
        var pageID: BehaviorRelay<Int>
        var songTapped: PublishSubject<Int> = PublishSubject()
        var allSongSelected: PublishSubject<Bool> = PublishSubject()
    }

    public struct Output {
        var canLoadMore: BehaviorRelay<Bool>
        var dataSource: BehaviorRelay<[ArtistSongListEntity]>
        let indexOfSelectedSongs: BehaviorRelay<[Int]>
        let songEntityOfSelectedSongs: BehaviorRelay<[SongEntity]>
    }

    public func transform(from input: Input) -> Output {
        let ID: String = model?.artistId ?? ""
        let type: ArtistSongSortType = self.type
        let fetchArtistSongListUseCase: FetchArtistSongListUseCase = self.fetchArtistSongListUseCase

        let dataSource: BehaviorRelay<[ArtistSongListEntity]> = BehaviorRelay(value: [])
        let canLoadMore: BehaviorRelay<Bool> = BehaviorRelay(value: true)
        let indexOfSelectedSongs: BehaviorRelay<[Int]> = BehaviorRelay(value: [])
        let songEntityOfSelectedSongs: BehaviorRelay<[SongEntity]> = BehaviorRelay(value: [])

        let refresh = Observable
            .combineLatest(dataSource, input.pageID) { dataSource, pageID -> [ArtistSongListEntity] in
                return pageID == 1 ? [] : dataSource
            }

        input.pageID
            .flatMap { pageID -> Single<[ArtistSongListEntity]> in
                return fetchArtistSongListUseCase
                    .execute(id: ID, sort: type, page: pageID)
                    .catchAndReturn([])
            }
            .asObservable()
            .do(onNext: { model in
                let loadMore: Bool = model.count < 30 ? false : true
                canLoadMore.accept(loadMore)
                // DEBUG_LOG("page: \(input.pageID.value) called, count: \(model.count), nextPage exist: \(loadMore)")
            }, onError: { _ in
                canLoadMore.accept(false)
            })
            .withLatestFrom(refresh, resultSelector: { newModels, datasources -> [ArtistSongListEntity] in
                return datasources + newModels
            })
            .bind(to: dataSource)
            .disposed(by: disposeBag)

        input.songTapped
            .withLatestFrom(indexOfSelectedSongs, resultSelector: { index, selectedSongs -> [Int] in
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
            .bind(to: indexOfSelectedSongs)
            .disposed(by: disposeBag)

        input.allSongSelected
            .withLatestFrom(dataSource) { ($0, $1) }
            .map { flag, dataSource -> [Int] in
                return flag ? Array(0 ..< dataSource.count) : []
            }
            .bind(to: indexOfSelectedSongs)
            .disposed(by: disposeBag)

        Utility.PreferenceManager.$startPage
            .skip(1)
            .map { _ in [] }
            .bind(to: indexOfSelectedSongs)
            .disposed(by: disposeBag)

        indexOfSelectedSongs
            .withLatestFrom(dataSource) { ($0, $1) }
            .map { selectedSongs, dataSource in
                var newModel = dataSource
                newModel.indices.forEach { newModel[$0].isSelected = false }

                selectedSongs.forEach { i in
                    newModel[i].isSelected = true
                }
                return newModel
            }
            .bind(to: dataSource)
            .disposed(by: disposeBag)

        indexOfSelectedSongs
            .withLatestFrom(dataSource) { ($0, $1) }
            .map { indexOfSelectedSongs, dataSource in
                return indexOfSelectedSongs.map {
                    SongEntity(
                        id: dataSource[$0].songId,
                        title: dataSource[$0].title,
                        artist: dataSource[$0].artist,
                        remix: dataSource[$0].remix,
                        reaction: dataSource[$0].reaction,
                        views: dataSource[$0].views,
                        last: dataSource[$0].last,
                        date: dataSource[$0].date
                    )
                }
            }
            .bind(to: songEntityOfSelectedSongs)
            .disposed(by: disposeBag)

        return Output(
            canLoadMore: canLoadMore,
            dataSource: dataSource,
            indexOfSelectedSongs: indexOfSelectedSongs,
            songEntityOfSelectedSongs: songEntityOfSelectedSongs
        )
    }
}
