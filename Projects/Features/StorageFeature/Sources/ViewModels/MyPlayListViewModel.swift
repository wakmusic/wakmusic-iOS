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

public final class MyPlayListViewModel:ViewModelType {
    var fetchPlayListUseCase: FetchPlayListUseCase!
    var editPlayListOrderUseCase: EditPlayListOrderUseCase!
    var deletePlayListUseCase: DeletePlayListUseCase!
    var fetchPlayListDetailUseCase: FetchPlayListDetailUseCase!
    var disposeBag = DisposeBag()

    public struct Input {
        let playListLoad: BehaviorRelay<Void> = BehaviorRelay(value: ())
        let itemMoved: PublishSubject<ItemMovedEvent> = PublishSubject()
        let itemSelected: PublishSubject<IndexPath> = PublishSubject()
        let allPlayListSelected: PublishSubject<Bool> = PublishSubject()
        let addPlayList: PublishSubject<Void> = PublishSubject()
        let deletePlayList: PublishSubject<Void> = PublishSubject()
        let runEditing: PublishSubject<Void> = PublishSubject()
        let getPlayListDetail:PublishSubject<String> = PublishSubject()
    }

    public struct Output {
        let state: BehaviorRelay<EditState> = BehaviorRelay(value: EditState(isEditing: false, force: true))
        let dataSource: BehaviorRelay<[MyPlayListSectionModel]> = BehaviorRelay(value: [])
        let backUpdataSource: BehaviorRelay<[MyPlayListSectionModel]> = BehaviorRelay(value: [])
        let indexPathOfSelectedPlayLists: BehaviorRelay<[IndexPath]> = BehaviorRelay(value: [])
        let willAddPlayList: BehaviorRelay<[SongEntity]> = BehaviorRelay(value: [])
        let showToast: PublishRelay<String> = PublishRelay()
        let immediatelyPlaySongs:PublishSubject<[SongEntity]> = PublishSubject()
    }

    init(
        fetchPlayListUseCase: FetchPlayListUseCase,
        editPlayListOrderUseCase: EditPlayListOrderUseCase,
        deletePlayListUseCase: DeletePlayListUseCase,
        fetchPlayListDetailUseCase: FetchPlayListDetailUseCase
    ) {
        self.fetchPlayListUseCase = fetchPlayListUseCase
        self.editPlayListOrderUseCase = editPlayListOrderUseCase
        self.deletePlayListUseCase = deletePlayListUseCase
        self.fetchPlayListDetailUseCase = fetchPlayListDetailUseCase
        DEBUG_LOG("✅ \(Self.self) 생성")
    }
    
    public func transform(from input: Input) -> Output {
        let output = Output()
        
        Utility.PreferenceManager.$userInfo
            .skip(1)
            .filter { $0 != nil }
            .map { _ in () }
            .bind(to: input.playListLoad)
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.playListRefresh)
            .map{ _ in () }
            .bind(to: input.playListLoad)
            .disposed(by: disposeBag)

        input.playListLoad
            .flatMap{ [weak self] () -> Observable<[PlayListEntity]> in
                guard let self = self else{
                    return Observable.empty()
                }
                return self.fetchPlayListUseCase.execute()
                    .asObservable()
                    .catchAndReturn([])
            }
            .map { [MyPlayListSectionModel(model: 0, items: $0)] }
            .bind(to: output.dataSource, output.backUpdataSource)
            .disposed(by: disposeBag)
        
        input.itemSelected
            .withLatestFrom(output.indexPathOfSelectedPlayLists, resultSelector: { (indexPath, selectedPlayLists) -> [IndexPath] in
                if selectedPlayLists.contains(indexPath) {
                    guard let removeTargetIndex = selectedPlayLists.firstIndex(where: { $0 == indexPath }) else { return selectedPlayLists }
                    var newSelectedPlayLists = selectedPlayLists
                    newSelectedPlayLists.remove(at: removeTargetIndex)
                    return newSelectedPlayLists
                    
                }else{
                    return selectedPlayLists + [indexPath]
                }
            })
            .map { $0.sorted { $0 < $1 } }
            .bind(to: output.indexPathOfSelectedPlayLists)
            .disposed(by: disposeBag)
                
        input.itemMoved
            .withLatestFrom(output.dataSource) { ($0.sourceIndex, $0.destinationIndex, $1) }
            .withLatestFrom(output.indexPathOfSelectedPlayLists) { ($0.0, $0.1, $0.2, $1) }
            .map { (sourceIndexPath, destinationIndexPath, dataSource, selectedPlayLists) -> [MyPlayListSectionModel] in
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
                    if newSelectedPlayLists.count == selectedPlayLists.count {
                        break
                    }
                }
                output.indexPathOfSelectedPlayLists.accept(newSelectedPlayLists.sorted { $0 < $1 })
                
                let sectionModel = [MyPlayListSectionModel(model: 0, items: newModel)]
                return sectionModel
            }
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)
        
        input.allPlayListSelected
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .map { (flag, dataSource) -> [IndexPath] in
                if flag {
                    let itemCount = (dataSource.first?.items ?? []).count
                    return Array(0..<itemCount).map { IndexPath(row: $0, section: 0) }
                }else{
                    return []
                }
            }
            .bind(to: output.indexPathOfSelectedPlayLists)
            .disposed(by: disposeBag)

        input.runEditing
            .withLatestFrom(output.dataSource)
            .map { $0.first?.items.map { $0.key } ?? [] }
            .filter{ !$0.isEmpty }
            .do(onNext: { _ in
                output.indexPathOfSelectedPlayLists.accept([])
            })
            .flatMap{ [weak self] (ids: [String]) -> Observable<BaseEntity> in
                guard let self = self else{
                    return Observable.empty()
                }
                return self.editPlayListOrderUseCase.execute(ids: ids).asObservable()
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
                        
        input.addPlayList
            .withLatestFrom(output.indexPathOfSelectedPlayLists)
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .map{ (indexPathes, dataSource) -> [String] in
                let keys = indexPathes.map {
                    dataSource[$0.section].items[$0.row].key
                }
                return keys
            }
            .flatMap{ [weak self] (keys) -> Observable<[SongEntity]> in
                guard let `self` = self else { return Observable.empty() }
                return Observable.concat( 
                    keys.map {
                        self.fetchPlayListDetailUseCase
                            .execute(id: $0, type: .custom)
                            .catchAndReturn(PlayListDetailEntity(id: "", title: "", songs: [], public: false, key: "", creator_id: "", image: "", image_square_version: 1, image_version: 1))
                            .asObservable()
                            .map { $0.songs }
                    }
                ).scan([]) { (pre, new) in //총 [1], [1,2] ,[1,2,3] ... [1,2,3,4,5] 인데 last가 [1,2,3,4,5]
                    return pre + new
                }.takeLast(1)
            }
            .bind(to: output.willAddPlayList)
            .disposed(by: disposeBag)
        
        input.deletePlayList
            .withLatestFrom(output.indexPathOfSelectedPlayLists)
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .map{ (indexPathes, dataSource) -> [String] in
                return indexPathes.map {
                    dataSource[$0.section].items[$0.row].key
                }
            }
            .filter { !$0.isEmpty }
            .flatMap({ [weak self] (ids) -> Observable<BaseEntity> in
                guard let `self` = self else { return Observable.empty() }
                return self.deletePlayListUseCase.execute(ids: ids)
                    .catchAndReturn(BaseEntity(status: 400, description: "존재하지 않는 리스트입니다."))
                    .asObservable()
            })
            .do(onNext: { (model) in
                if model.status == 200 {
                    output.state.accept(EditState(isEditing: false, force: true))
                    output.indexPathOfSelectedPlayLists.accept([])
                }else{
                    output.showToast.accept(model.description)
                }
            })
            .map { _ in () }
            .bind(to: input.playListLoad)
            .disposed(by: disposeBag)
        
        output.indexPathOfSelectedPlayLists
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .map { (selectedPlayLists, dataSource) in
                var newModel = dataSource
                for i in 0..<newModel.count {
                    for j in 0..<newModel[i].items.count {
                        newModel[i].items[j].isSelected = false
                    }
                }
                selectedPlayLists.forEach {
                    newModel[$0.section].items[$0.row].isSelected = true
                }
                return newModel
            }
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)
        
        input.getPlayListDetail
            .flatMap{ [weak self] (key) -> Observable<[SongEntity]> in
                guard let `self` = self else { return Observable.empty() }
                return self.fetchPlayListDetailUseCase
                    .execute(id: key, type: .custom)
                    .asObservable()
                    .map { $0.songs }
               
            }
            .bind(to: output.immediatelyPlaySongs)
            .disposed(by: disposeBag)

        return output
    }
}
