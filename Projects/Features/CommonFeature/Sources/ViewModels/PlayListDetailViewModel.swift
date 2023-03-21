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
import DataMappingModule
import Utility

struct PlayListHeaderInfo {
    var title:String
    var songCount:String
    var image:String
    var version:Int
}

public final class PlayListDetailViewModel:ViewModelType {
   
    let input = Input()
    let output = Output()
    
    var type:PlayListType!
    var id:String!
    var key:String?
    var fetchPlayListDetailUseCase:FetchPlayListDetailUseCase!
    var editPlayListUseCase : EditPlayListUseCase!
    var disposeBag = DisposeBag()

    public struct Input {
        let textString:BehaviorRelay<String> = BehaviorRelay(value: "")
        let sourceIndexPath:BehaviorRelay<IndexPath> = BehaviorRelay(value: IndexPath(row: 0, section: 0))
        let destIndexPath:BehaviorRelay<IndexPath> = BehaviorRelay(value: IndexPath(row: 0, section: 0))
        let showErrorToast:PublishRelay<String> = PublishRelay()
        let playListNameLoad:BehaviorRelay<String> = BehaviorRelay(value: "")
        let cancelEdit:PublishSubject<Void> = PublishSubject()
        let runEditing:PublishSubject<Void> = PublishSubject()
        let songTapped: PublishSubject<Int> = PublishSubject()
        let allSongSelected: PublishSubject<Bool> = PublishSubject()
    
        
    }

    public struct Output {
        let state:BehaviorRelay<EditState> = BehaviorRelay(value:EditState(isEditing: false, force: false))
        let headerInfo:PublishRelay<PlayListHeaderInfo> = PublishRelay()
        let dataSource:BehaviorRelay<[PlayListDetailSectionModel]> = BehaviorRelay(value: [])
        let backUpdataSource:BehaviorRelay<[PlayListDetailSectionModel]> = BehaviorRelay(value: [])
        let indexOfSelectedSongs: BehaviorRelay<[Int]> = BehaviorRelay(value: [])
        let songEntityOfSelectedSongs: BehaviorRelay<[SongEntity]> = BehaviorRelay(value: [])
        
    }

    public init(id:String,type:PlayListType,fetchPlayListDetailUseCase:FetchPlayListDetailUseCase,editPlayListUseCase:EditPlayListUseCase) {
        
        self.id = id
        self.type = type
        self.fetchPlayListDetailUseCase = fetchPlayListDetailUseCase
        self.editPlayListUseCase = editPlayListUseCase
        
       
       
        
        
        fetchPlayListDetailUseCase.execute(id: id, type: type)
            .catchAndReturn(PlayListDetailEntity(id: "", title: "", songs: [], public: true, key: "", creator_id: "", image: "", image_square_version: 1, image_version: 1))
        .asObservable()
        .do(onNext: { [weak self] (model) in
            
            guard let self = self else{
                return
            }
            
            
            self.output.headerInfo.accept(PlayListHeaderInfo(title: model.title, songCount: "\(model.songs.count)곡",
                                                             image: type == .wmRecommend ? model.id : model.image,version: type == .wmRecommend ? model.image_square_version : model.image_version))
            
            self.key = model.key
            
        })
        .map { [PlayListDetailSectionModel(model: 0, items: $0.songs)] }
        .bind(to: output.dataSource,output.backUpdataSource)
        .disposed(by: disposeBag)
            
        
        input.playListNameLoad
            .skip(1)
            .withLatestFrom(output.headerInfo){($0,$1)}
            .map({PlayListHeaderInfo(title: $0.0, songCount: $0.1.songCount, image: $0.1.image,version: $0.1.version)})
            .bind(to: output.headerInfo)
            .disposed(by: disposeBag)
            
        input.runEditing
            .withLatestFrom(output.dataSource)
            .filter { !($0.first?.items ?? []).isEmpty }
            .map { $0.first?.items.map { $0.id } ?? [] }
            .debug("서버로 전송합니다.")
            .flatMap({[weak self] (songs:[String]) -> Observable<BaseEntity> in
                
                guard let self = self else{
                    return Observable.empty()
                }
                
                guard let key = self.key else {
                    return Observable.empty()
                }
                return self.editPlayListUseCase.execute(key: key, songs: songs)
                    .asObservable()
            }).subscribe(onNext: { [weak self] in
                guard let self = self else{
                    return
                }
                if $0.status != 200 {
                    self.input.showErrorToast.accept($0.description)
                    return
                }
                self.output.backUpdataSource.accept(self.output.dataSource.value)
            }).disposed(by: disposeBag)
                
        input.cancelEdit
            .withLatestFrom(output.backUpdataSource)
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)
        
        
        
        
    }
    
    deinit{
        DEBUG_LOG("❌ PlayListDetailViewModel 소멸")
    }
    
    public func transform(from input: Input) -> Output {
        
        let output = Output()
        
      
        
        
        input.songTapped
            .withLatestFrom(output.indexOfSelectedSongs, resultSelector: { (index, selectedSongs) -> [Int] in
                if selectedSongs.contains(index) {
                    guard let removeTargetIndex = selectedSongs.firstIndex(where: { $0 == index }) else { return selectedSongs }
                    var newSelectedSongs = selectedSongs
                    newSelectedSongs.remove(at: removeTargetIndex)
                    return newSelectedSongs
                    
                }else{
                    return selectedSongs + [index]
                }
            })
            .map { $0.sorted { $0 < $1 } }
            .bind(to: output.indexOfSelectedSongs)
            .disposed(by: disposeBag)
        
        input.allSongSelected
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .map { (flag, dataSource) -> [Int] in
                return flag ? Array(0..<dataSource.count) : []
            }
            .bind(to: output.indexOfSelectedSongs)
            .disposed(by: disposeBag)
        
        
        output.indexOfSelectedSongs
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .map { (selectedSongs, dataSource) in
                var newModel = dataSource
                
                var realData = newModel.first?.items ?? []
                
                realData.indices.forEach({
                
                    realData[$0].isSelected = false
                    
                    selectedSongs.forEach { i in
                        realData[i].isSelected = true
                    }
                })
                
                
               
                
                return newModel
            }
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)
        
        
        output.indexOfSelectedSongs
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .map { (indexOfSelectedSongs, dataSource) in
                
                
                
                
                let song = dataSource.first?.items ?? []
                
                return indexOfSelectedSongs.map {
                    
                    
                    
                    SongEntity(
                        id: song[$0].id,
                        title: song[$0].title,
                        artist: song[$0].artist,
                        remix: song[$0].remix,
                        reaction: song[$0].reaction,
                        views: song[$0].views,
                        last: song[$0].last,
                        date: song[$0].date
                    )
                }
            }
            .bind(to: output.songEntityOfSelectedSongs)
            .disposed(by: disposeBag)
        
        
        
        return output
        
    }
    
    
    
}
