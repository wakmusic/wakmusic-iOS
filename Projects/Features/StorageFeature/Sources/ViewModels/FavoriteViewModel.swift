//
//  FavoriteViewModel.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/27.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation 
import RxSwift
import RxRelay
import RxCocoa
import BaseFeature
import DomainModule
import Utility
import CommonFeature

public final class FavoriteViewModel:ViewModelType {
    
    var disposeBag = DisposeBag()
    var fetchFavoriteSongsUseCase: FetchFavoriteSongsUseCase!
    var editFavoriteSongsOrderUseCase: EditFavoriteSongsOrderUseCase!
    var deleteFavoriteListUseCase: DeleteFavoriteListUseCase!
    var tempDeleteLikeListIds: [String] = []
    
    public struct Input {
        let likeListLoad: BehaviorRelay<Void> = BehaviorRelay(value: ())
        let itemMoved: PublishSubject<ItemMovedEvent> = PublishSubject()
        let itemSelected: PublishSubject<IndexPath> = PublishSubject()
        let allLikeListSelected: PublishSubject<Bool> = PublishSubject()
        let addSongs: PublishSubject<Void> = PublishSubject()
        let addPlayList: PublishSubject<Void> = PublishSubject()
        let deleteLikeList: PublishSubject<Void> = PublishSubject()
        let runEditing: PublishSubject<Void> = PublishSubject()
    }

    public struct Output {
        let state: BehaviorRelay<EditState> = BehaviorRelay(value: EditState(isEditing: false, force: true))
        let dataSource: BehaviorRelay<[FavoriteSectionModel]> = BehaviorRelay(value: [])
        let backUpdataSource:BehaviorRelay<[FavoriteSectionModel]> = BehaviorRelay(value: [])
        let indexPathOfSelectedLikeLists: BehaviorRelay<[IndexPath]> = BehaviorRelay(value: [])
        let willAddSongList: BehaviorRelay<[String]> = BehaviorRelay(value: [])
        let willAddPlayList: BehaviorRelay<[SongEntity]> = BehaviorRelay(value: [])
        let showToast: PublishRelay<String> = PublishRelay()
    }

    init(
        fetchFavoriteSongsUseCase: FetchFavoriteSongsUseCase,
        editFavoriteSongsOrderUseCase: EditFavoriteSongsOrderUseCase,
        deleteFavoriteListUseCase: DeleteFavoriteListUseCase
    ) {
        DEBUG_LOG("✅ \(Self.self) 생성")
        self.fetchFavoriteSongsUseCase = fetchFavoriteSongsUseCase
        self.editFavoriteSongsOrderUseCase = editFavoriteSongsOrderUseCase
        self.deleteFavoriteListUseCase = deleteFavoriteListUseCase
    }
    
    public func transform(from input: Input) -> Output {
        let output = Output()
        
        Utility.PreferenceManager.$userInfo
            .skip(1)
            .filter { $0 != nil }
            .map { _ in () }
            .bind(to: input.likeListLoad)
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.likeListRefresh)
            .map{ _ in () }
            .bind(to: input.likeListLoad)
            .disposed(by: disposeBag)
        
        input.likeListLoad
            .flatMap { [weak self] _ -> Observable<[FavoriteSongEntity]> in
                guard let self = self else{ return Observable.empty() }
                return self.fetchFavoriteSongsUseCase.execute()
                    .catchAndReturn([])
                    .asObservable()
            }
            .map { [FavoriteSectionModel(model: 0, items: $0)] }
            .bind(to: output.dataSource, output.backUpdataSource)
            .disposed(by: disposeBag)
        
        input.itemSelected
            .withLatestFrom(output.indexPathOfSelectedLikeLists, resultSelector: { (indexPath, selectedLikeLists) -> [IndexPath] in
                if selectedLikeLists.contains(indexPath) {
                    guard let removeTargetIndex = selectedLikeLists.firstIndex(where: { $0 == indexPath }) else { return selectedLikeLists }
                    var newSelectedPlayLists = selectedLikeLists
                    newSelectedPlayLists.remove(at: removeTargetIndex)
                    return newSelectedPlayLists
                    
                }else{
                    return selectedLikeLists + [indexPath]
                }
            })
            .map { $0.sorted { $0 < $1 } }
            .bind(to: output.indexPathOfSelectedLikeLists)
            .disposed(by: disposeBag)
                
        input.itemMoved
            .withLatestFrom(output.dataSource) { ($0.sourceIndex, $0.destinationIndex, $1) }
            .withLatestFrom(output.indexPathOfSelectedLikeLists) { ($0.0, $0.1, $0.2, $1) }
            .map { (sourceIndexPath, destinationIndexPath, dataSource, selectedLikeLists) -> [FavoriteSectionModel] in
                //데이터 소스의 이동
                var newModel = dataSource.first?.items ?? []
                let temp = newModel[sourceIndexPath.row]
                newModel.remove(at: sourceIndexPath.row)
                newModel.insert(temp, at: destinationIndexPath.row)

                //선택 된 플레이리스트 인덱스 패스 변경
                var newSelectedPlayLists: [IndexPath] = []
                for i in 0..<newModel.count {
                    if newModel[i].isSelected {
                        newSelectedPlayLists.append(IndexPath(row: i, section: 0))
                    }
                    if newSelectedPlayLists.count == selectedLikeLists.count {
                        break
                    }
                }
                output.indexPathOfSelectedLikeLists.accept(newSelectedPlayLists.sorted { $0 < $1 })
                
                let sectionModel = [FavoriteSectionModel(model: 0, items: newModel)]
                return sectionModel
            }
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)
        
        input.allLikeListSelected
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .map { (flag, dataSource) -> [IndexPath] in
                if flag {
                    let itemCount = (dataSource.first?.items ?? []).count
                    return Array(0..<itemCount).map { IndexPath(row: $0, section: 0) }
                }else{
                    return []
                }
            }
            .bind(to: output.indexPathOfSelectedLikeLists)
            .disposed(by: disposeBag)

        input.runEditing
            .withLatestFrom(output.dataSource)
            .map { $0.first?.items.map { $0.song.id } ?? [] }
            .filter{ !$0.isEmpty }
            .do(onNext: { _ in
                output.indexPathOfSelectedLikeLists.accept([])
            })
            .flatMap{ [weak self] (ids: [String]) -> Observable<BaseEntity> in
                guard let self = self else{
                    return Observable.empty()
                }
                return self.editFavoriteSongsOrderUseCase.execute(ids: ids)
                    .asObservable()
            }
            .filter{ (model) in
                guard model.status == 200 else {
                    output.showToast.accept(model.description)
                    return false
                }
                return true
            }
            .withLatestFrom(output.dataSource)
            .bind(to: output.backUpdataSource)
            .disposed(by: disposeBag)
        
        //노래담기
        input.addSongs
            .withLatestFrom(output.indexPathOfSelectedLikeLists)
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .map{ (indexPathes, dataSource) -> [String] in
                let ids = indexPathes.map {
                    dataSource[$0.section].items[$0.row].song.id
                }
                return ids
            }
            .bind(to: output.willAddSongList)
            .disposed(by: disposeBag)

        //재생목록추가
        input.addPlayList 
            .withLatestFrom(output.indexPathOfSelectedLikeLists)
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .map{ (indexPathes, dataSource) -> [SongEntity] in
                let songs = indexPathes.map {
                    dataSource[$0.section].items[$0.row].song
                }
                return songs
            }
            .bind(to: output.willAddPlayList)
            .disposed(by: disposeBag)
        
        input.deleteLikeList
            .withLatestFrom(output.indexPathOfSelectedLikeLists)
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .map{ (indexPathes, dataSource) -> [String] in
                return indexPathes.map {
                    dataSource[$0.section].items[$0.row].song.id
                }
            }
            .filter { !$0.isEmpty }
            .flatMap({ [weak self] (ids) -> Observable<BaseEntity> in
                guard let `self` = self else { return Observable.empty() }
                self.tempDeleteLikeListIds = ids
                return self.deleteFavoriteListUseCase.execute(ids: ids)
                    .catchAndReturn(BaseEntity(status: 400, description: "존재하지 않는 리스트입니다."))
                    .asObservable()
            })
            .do(onNext: { [weak self] (model) in
                guard let `self` = self else { return }
                output.state.accept(EditState(isEditing: false, force: true))
                output.indexPathOfSelectedLikeLists.accept([])

                if model.status == 200 {
                    output.showToast.accept("좋아요 리스트에서 삭제되었습니다.")
                    
                    //좋아요 삭제 시 > 노티피케이션
                    guard let currentSong: SongEntity = PlayState.shared.currentSong else { return }
                    let currentSongID: String = currentSong.id
                    if self.tempDeleteLikeListIds.contains(currentSongID) {
                        DEBUG_LOG("updateCurrentSongLikeState ID: \(currentSongID)")
                        NotificationCenter.default.post(name: .updateCurrentSongLikeState, object: currentSong)
                    }
                }else{
                    output.showToast.accept(model.description)
                }
            })
            .map { _ in () }
            .bind(to: input.likeListLoad)
            .disposed(by: disposeBag)
        
        output.indexPathOfSelectedLikeLists
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .map { (selectedLikeLists, dataSource) in
                var newModel = dataSource
                for i in 0..<newModel.count {
                    for j in 0..<newModel[i].items.count {
                        newModel[i].items[j].isSelected = false
                    }
                }
                selectedLikeLists.forEach {
                    newModel[$0.section].items[$0.row].isSelected = true
                }
                return newModel
            }
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)
        
        return output
    }
}
