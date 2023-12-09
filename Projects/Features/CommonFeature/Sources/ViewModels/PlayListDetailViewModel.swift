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
import ErrorModule
import RxCocoa

struct PlayListHeaderInfo {
    var title:String
    var songCount:String
    var image:String
    var version:Int
}

public final class PlayListDetailViewModel: ViewModelType {
    var type: PlayListType!
    var id: String!
    var key: String?
    var fetchPlayListDetailUseCase: FetchPlayListDetailUseCase!
    var editPlayListUseCase: EditPlayListUseCase!
    var removeSongsUseCase: RemoveSongsUseCase!
    var disposeBag = DisposeBag()

    public struct Input {
        let textString: BehaviorRelay<String> = BehaviorRelay(value: "")
        let itemMoved: PublishSubject<ItemMovedEvent> = PublishSubject()
        let playListNameLoad: BehaviorRelay<String> = BehaviorRelay(value: "")
        let cancelEdit: PublishSubject<Void> = PublishSubject()
        let runEditing: PublishSubject<Void> = PublishSubject()
        let songTapped: PublishSubject<Int> = PublishSubject()
        let allSongSelected: PublishSubject<Bool> = PublishSubject()
        let tapRemoveSongs: PublishSubject<Void> = PublishSubject()
        let state: BehaviorRelay<EditState> = BehaviorRelay(value:EditState(isEditing: false, force: false))
        let groupPlayTapped: PublishSubject<PlayEvent> = PublishSubject()
    }

    public struct Output {
        let headerInfo: PublishRelay<PlayListHeaderInfo> = PublishRelay()
        let dataSource: BehaviorRelay<[PlayListDetailSectionModel]> = BehaviorRelay(value: [])
        let backUpdataSource: BehaviorRelay<[PlayListDetailSectionModel]> = BehaviorRelay(value: [])
        let indexOfSelectedSongs: BehaviorRelay<[Int]> = BehaviorRelay(value: [])
        let songEntityOfSelectedSongs: BehaviorRelay<[SongEntity]> = BehaviorRelay(value: [])
        let refreshPlayList: BehaviorRelay<Void> = BehaviorRelay(value: ())
        let groupPlaySongs: PublishSubject<[SongEntity]> = PublishSubject()
        let showErrorToast: PublishRelay<BaseEntity> = PublishRelay()
    }

    public init(
        id: String,
        type: PlayListType,
        fetchPlayListDetailUseCase: FetchPlayListDetailUseCase,
        editPlayListUseCase: EditPlayListUseCase,
        removeSongsUseCase: RemoveSongsUseCase
    ) {
        self.id = id
        self.type = type
        self.fetchPlayListDetailUseCase = fetchPlayListDetailUseCase
        self.editPlayListUseCase = editPlayListUseCase
        self.removeSongsUseCase = removeSongsUseCase
    }
    
    deinit{
        DEBUG_LOG("❌ \(Self.self) 소멸")
    }
    
    public func transform(from input: Input) -> Output {
        let output = Output()
        
        output.refreshPlayList
            .flatMap({ [weak self] () -> Observable<PlayListDetailEntity> in
                guard let self = self else {return Observable.empty()}
                return self.fetchPlayListDetailUseCase.execute(id: self.id, type: self.type)
                    .catchAndReturn(
                        PlayListDetailEntity(key: "", title: "", songs: [], image: "", image_square_version: 0, image_round_version: 0, version: 0)
                    )
                    .asObservable()
                    .do(onNext: { [weak self] (model) in
                        guard let self = self else { return }
                        output.headerInfo.accept(
                            PlayListHeaderInfo(
                                title: model.title,
                                songCount: "\(model.songs.count)곡",
                                image: self.type == .wmRecommend ?
                                model.key : model.image,version: self.type == .wmRecommend ?
                                model.image_square_version : model.version
                            )
                        )
                        self.key = model.key
                    })
                })
            .map { [PlayListDetailSectionModel(model: 0, items: $0.songs)] }
            .bind(to: output.dataSource, output.backUpdataSource)
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
            .do(onNext: { _ in
                output.indexOfSelectedSongs.accept([]) //  바텀 Tab 내려가게 하기 위해
                output.songEntityOfSelectedSongs.accept([]) //  바텀 Tab 내려가게 하기 위해
            })
            .filter{ (ids: [String]) -> Bool in
                let beforeIds: [String] = output.backUpdataSource.value.first?.items.map { $0.id } ?? []
                let elementsEqual: Bool = beforeIds.elementsEqual(ids)
                DEBUG_LOG(elementsEqual ? "❌ 변경된 내용이 없습니다." : "✅ 리스트가 변경되었습니다.")
                return elementsEqual == false
            }
            .flatMap{ [weak self] (songs: [String]) -> Observable<BaseEntity> in
                guard let self = self, let key = self.key else {
                    return Observable.empty()
                }
                return self.editPlayListUseCase.execute(key: key, songs: songs)
                    .catch({ (error:Error) in
                        let wmError = error.asWMError
                        
                        if wmError == .tokenExpired {
                            return Single<BaseEntity>.create { single in
                                single(.success(BaseEntity(status: 401, description: error.asWMError.errorDescription ?? "")))
                                return Disposables.create {}
                            }
                        }
                        
                        else {
                            return Single<BaseEntity>.create { single in
                                single(.success(BaseEntity(status: 0, description: error.asWMError.errorDescription ?? "")))
                                return Disposables.create {}
                            }
                        }
                    })
                    .asObservable()
            }
            .subscribe(onNext: { (model) in
                if model.status != 200 {
                    output.showErrorToast.accept(model)
                    return
                }
                output.refreshPlayList.accept(())
                NotificationCenter.default.post(name: .playListRefresh, object: nil) // 바깥 플리 업데이트
            }).disposed(by: disposeBag)
                
        input.cancelEdit
            .withLatestFrom(output.backUpdataSource)
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)
              
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
                return flag ? Array(0..<dataSource.first!.items.count) : []
            }
            .bind(to: output.indexOfSelectedSongs)
            .disposed(by: disposeBag)
                
        input.tapRemoveSongs
            .withLatestFrom(output.songEntityOfSelectedSongs)
            .map{ (entities: [SongEntity]) -> [String] in
                return entities.map { $0.id }
            }
            .flatMap{ [weak self] (songs: [String]) -> Observable<BaseEntity> in
                guard let self = self, let key = self.key else {
                    return Observable.empty()
                }
                return self.removeSongsUseCase.execute(key: key, songs: songs)
                    .catch({ (error:Error) in
                        let wmError = error.asWMError
                        if wmError == .tokenExpired {
                            return Single<BaseEntity>.create { single in
                                single(.success(BaseEntity(status: 401, description: error.asWMError.errorDescription ?? "")))
                                return Disposables.create {}
                            }
                            
                        }else {
                            return Single<BaseEntity>.create { single in
                                single(.success(BaseEntity(status: 0, description: error.asWMError.errorDescription ?? "")))
                                return Disposables.create {}
                            }
                        }
                    })
                    .asObservable()
            }
            .subscribe(onNext: { (model) in
                output.showErrorToast.accept((model.status == 200) ? BaseEntity(status: 200, description: "리스트에서 삭제되었습니다.") : model)
                output.refreshPlayList.accept(())
                output.indexOfSelectedSongs.accept([])
                output.songEntityOfSelectedSongs.accept([])
                NotificationCenter.default.post(name: .playListRefresh, object: nil)
            }).disposed(by: disposeBag)

        input.itemMoved
            .subscribe(onNext: { (itemMovedEvent) in
                let source = itemMovedEvent.sourceIndex.row
                let dest = itemMovedEvent.destinationIndex.row
                var curr = output.dataSource.value.first?.items ?? []
                let tmp = curr[source]
                
                curr.remove(at:  source)
                curr.insert(tmp, at: dest)
                
                let newModel = [PlayListDetailSectionModel(model: 0, items: curr)]
                output.dataSource.accept(newModel)
                
                //꼭 먼저 데이터 소스를 갱신 해야합니다
                
                var indexs = output.indexOfSelectedSongs.value // 현재 선택된 인덱스 모음
                let limit = curr.count - 1 // 마지막 인덱스
                
                let sourceIsSelected:Bool = indexs.contains(where: {$0 == source}) // 선택된 것을 움직 였는지 ?
               
                if  sourceIsSelected {
                    //선택된 인덱스 배열 안에 source(시작점)이 있다는 뜻은 선택된 것을 옮긴다는 뜻

                    let pos = indexs.firstIndex(where: {$0 == source})!
                    indexs.remove(at: pos)
                    //그러므로 일단 지워준다.
                }
                
                indexs = indexs
                    .map({ i -> Int in
                        //i: 현재 저장된 인덱스들을 순회함
                        if  source < i && i > dest {
                            // 옮기기 시작한 위치와 도착한 위치가 i를 기준으로 앞일 때 아무 영향 없음
                            return i
                        }
                        if source < i && i <= dest {
                            /* 옮기기 시작한 위치는 i 앞
                               도착한 위치가 i또는 i 뒤일 경우
                                i는 앞으로 한 칸 가야함
                             */
                            return i - 1
                        }
                        if   i < source  &&   dest <= i {
                            /* 옮기기 시작한 위치는 i 뒤
                               도착한 위치가 i또는 i 앞일 경우
                                i는 뒤로 한칸 가야함
                             
                                ** 단 옮겨질 위치가  배열의 끝일 경우는 그대로 있음
                             */
                            return i + 1
                        }
                        if source > i && i < dest {
                            /* 옮기기 시작한 위치는 i 뒤
                               도착한 위치가 i 뒤 일경우
                             
                                아무 영향 없음
                             */
                            return i
                        }
                        return i
                    })
                if sourceIsSelected { // 선택된 것을 건드렸으므로 dest 인덱스로 갱신하여 넣어준다
                    indexs.append(dest)
                }
                
                indexs.sort()
                
                DEBUG_LOG("sourceIndexPath: \(source)")
                DEBUG_LOG("destIndexPath: \(dest)")
                DEBUG_LOG("dataSource: \(curr.map({$0.title}))")
                DEBUG_LOG("indexs: \(indexs)")
                output.indexOfSelectedSongs.accept(indexs)
                
            }).disposed(by: disposeBag)
        
        input.groupPlayTapped
            .withLatestFrom(output.dataSource){($0,$1)}
            .map({ (type,dataSourc) -> [SongEntity] in
                guard let songs = dataSourc.first?.items as? [SongEntity] else {
                    return []
                }
                switch type {
                case .allPlay:
                    return songs
                case .shufflePlay:
                    return songs.shuffled()
                }
            })
            .bind(to: output.groupPlaySongs)
            .disposed(by: disposeBag)
        
        output.indexOfSelectedSongs
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .map { (selectedSongs, dataSource) -> [PlayListDetailSectionModel] in
                var realData = dataSource.first?.items ?? []
                realData.indices.forEach({
                    realData[$0].isSelected = false
                })
                selectedSongs.forEach { i in
                    realData[i].isSelected = true
                }
                return [PlayListDetailSectionModel(model: 0, items: realData)]
            }
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)
        
        output.indexOfSelectedSongs
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .map { (indexOfSelectedSongs, dataSource) -> [SongEntity] in
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

        NotificationCenter.default.rx.notification(.playListNameRefresh)
            .map{ (notification) -> String in
                guard let obj = notification.object as? String else {
                    return ""
                }
                return obj
            }
            .do(onNext: { _ in
                input.state.accept(EditState(isEditing: false, force: true))
                input.cancelEdit.onNext(())
            })
            .bind(to: input.playListNameLoad)
            .disposed(by: disposeBag)

        return output
    }
}
