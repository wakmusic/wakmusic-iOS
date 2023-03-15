//
//  ArtistMusicContentViewModel.swift
//  ArtistFeature
//
//  Created by KTH on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import BaseFeature
import DomainModule
import DataMappingModule
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
    ){
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
        let selectedSongs: BehaviorRelay<[Int]>
    }
    
    public func transform(from input: Input) -> Output {
        let ID: String = model?.ID ?? ""
        let type: ArtistSongSortType = self.type
        let fetchArtistSongListUseCase: FetchArtistSongListUseCase = self.fetchArtistSongListUseCase
        
        let dataSource: BehaviorRelay<[ArtistSongListEntity]> = BehaviorRelay(value: [])
        let canLoadMore: BehaviorRelay<Bool> = BehaviorRelay(value: true)
        let selectedSongs: BehaviorRelay<[Int]> = BehaviorRelay(value: [])

        let refresh = Observable.combineLatest(dataSource, input.pageID) { (dataSource, pageID) -> [ArtistSongListEntity] in
            return pageID == 1 ? [] : dataSource
        }

        input.pageID
            .flatMap { (pageID) -> Single<[ArtistSongListEntity]> in
                return fetchArtistSongListUseCase
                        .execute(id: ID, sort: type, page: pageID)
                        .catchAndReturn([])
            }
            .asObservable()
            .do(onNext: { (model) in
                canLoadMore.accept(!model.isEmpty)
//                DEBUG_LOG("page: \(input.pageID.value) called, nextPage exist: \(!model.isEmpty)")
            }, onError: { _ in
                canLoadMore.accept(false)
            })
            .withLatestFrom(refresh, resultSelector: { (newModels, datasources) -> [ArtistSongListEntity] in
                return datasources + newModels
            })
            .bind(to: dataSource)
            .disposed(by: disposeBag)
                
        input.songTapped
            .withLatestFrom(selectedSongs, resultSelector: { (songIndex, selectedSongs) -> [Int] in
                if selectedSongs.contains(songIndex) {
                    guard let removeTargetIndex = selectedSongs.firstIndex(where: { $0 == songIndex }) else { return selectedSongs }
                    var newSelectedSongs = selectedSongs
                    newSelectedSongs.remove(at: removeTargetIndex)
                    return newSelectedSongs
                    
                }else{
                    return selectedSongs + [songIndex]
                }
            })
            .map { $0.sorted { $0 < $1 } }
            .bind(to: selectedSongs)
            .disposed(by: disposeBag)
        
        input.allSongSelected
            .withLatestFrom(dataSource) { ($0, $1) }
            .map { (flag, dataSource) -> [Int] in
                return flag ? Array(0..<dataSource.count) : []
            }
            .bind(to: selectedSongs)
            .disposed(by: disposeBag)
        
        selectedSongs
            .withLatestFrom(dataSource) { ($0, $1) }
            .map { (selectedSongs, dataSource) in
                var newModel = dataSource
                newModel.indices.forEach { newModel[$0].isSelected = false }

                selectedSongs.forEach { i in
                    newModel[i].isSelected = true
                }
                return newModel
            }
            .bind(to: dataSource)
            .disposed(by: disposeBag)
        
        return Output(
            canLoadMore: canLoadMore,
            dataSource: dataSource,
            selectedSongs: selectedSongs
        )
    }
}
