//
//  ArtistMusicContentViewModel.swift
//  ArtistFeature
//
//  Created by KTH on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import ArtistDomainInterface
import BaseFeature
import Foundation
import LogManager
import RxCocoa
import RxSwift
import SongsDomainInterface
import Utility

public final class ArtistMusicContentViewModel: ViewModelType {
    private let fetchArtistSongListUseCase: FetchArtistSongListUseCase
    var type: ArtistSongSortType
    var model: ArtistEntity?
    private let disposeBag = DisposeBag()

    public init(
        type: ArtistSongSortType,
        model: ArtistEntity?,
        fetchArtistSongListUseCase: any FetchArtistSongListUseCase
    ) {
        self.type = type
        self.model = model
        self.fetchArtistSongListUseCase = fetchArtistSongListUseCase
    }

    public struct Input {
        let pageID: BehaviorRelay<Int> = BehaviorRelay(value: 1)
        let songTapped: PublishSubject<Int> = PublishSubject()
        let allSongSelected: PublishSubject<Bool> = PublishSubject()
    }

    public struct Output {
        let canLoadMore: BehaviorRelay<Bool> = BehaviorRelay(value: true)
        let dataSource: BehaviorRelay<[ArtistSongListEntity]> = BehaviorRelay(value: [])
        let indexOfSelectedSongs: BehaviorRelay<[Int]> = BehaviorRelay(value: [])
        let songEntityOfSelectedSongs: BehaviorRelay<[SongEntity]> = BehaviorRelay(value: [])
        let showToast: PublishSubject<String> = .init()
        let showLogin: PublishSubject<CommonAnalyticsLog.LoginButtonEntry> = .init()
    }

    public func transform(from input: Input) -> Output {
        let output = Output()
        let ID: String = self.model?.id ?? ""
        let type: ArtistSongSortType = self.type
        let fetchArtistSongListUseCase: FetchArtistSongListUseCase = self.fetchArtistSongListUseCase

        let refresh = Observable
            .combineLatest(output.dataSource, input.pageID) { dataSource, pageID -> [ArtistSongListEntity] in
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
                output.canLoadMore.accept(loadMore)
                // DEBUG_LOG("page: \(input.pageID.value) called, count: \(model.count), nextPage exist: \(loadMore)")
            }, onError: { _ in
                output.canLoadMore.accept(false)
            })
            .withLatestFrom(refresh, resultSelector: { newModels, datasources -> [ArtistSongListEntity] in
                return datasources + newModels
            })
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)

        input.songTapped
            .withLatestFrom(output.indexOfSelectedSongs, resultSelector: { index, selectedSongs -> [Int] in
                let songID: String = output.dataSource.value[index].songID
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
            .map { indexOfSelectedSongs, dataSource in
                return indexOfSelectedSongs.map {
                    SongEntity(
                        id: dataSource[$0].songID,
                        title: dataSource[$0].title,
                        artist: dataSource[$0].artist,
                        views: 0,
                        date: dataSource[$0].date
                    )
                }
            }
            .bind(to: output.songEntityOfSelectedSongs)
            .disposed(by: disposeBag)

        return output
    }
}
