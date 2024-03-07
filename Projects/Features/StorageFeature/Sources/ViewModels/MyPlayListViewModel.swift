//
//  FavoriteViewModel.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/27.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import BaseFeature
import CommonFeature
import DomainModule
import Foundation
import RxCocoa
import RxRelay
import RxSwift
import Utility

public final class MyPlayListViewModel: ViewModelType {
    var fetchPlayListUseCase: FetchPlayListUseCase!
    var editPlayListOrderUseCase: EditPlayListOrderUseCase!
    var deletePlayListUseCase: DeletePlayListUseCase!
    var disposeBag = DisposeBag()

    public struct Input {
        let playListLoad: BehaviorRelay<Void> = BehaviorRelay(value: ())
        let itemMoved: PublishSubject<ItemMovedEvent> = PublishSubject()
        let itemSelected: PublishSubject<IndexPath> = PublishSubject()
        let allPlayListSelected: PublishSubject<Bool> = PublishSubject()
        let addPlayList: PublishSubject<Void> = PublishSubject()
        let deletePlayList: PublishSubject<Void> = PublishSubject()
        let runEditing: PublishSubject<Void> = PublishSubject()
    }

    public struct Output {
        let state: BehaviorRelay<EditState> = BehaviorRelay(value: EditState(isEditing: false, force: true))
        let dataSource: BehaviorRelay<[MyPlayListSectionModel]> = BehaviorRelay(value: [])
        let backUpdataSource: BehaviorRelay<[MyPlayListSectionModel]> = BehaviorRelay(value: [])
        let indexPathOfSelectedPlayLists: BehaviorRelay<[IndexPath]> = BehaviorRelay(value: [])
        let willAddPlayList: BehaviorRelay<[SongEntity]> = BehaviorRelay(value: [])
        let showToast: PublishRelay<BaseEntity> = PublishRelay()
    }

    init(
        fetchPlayListUseCase: FetchPlayListUseCase,
        editPlayListOrderUseCase: EditPlayListOrderUseCase,
        deletePlayListUseCase: DeletePlayListUseCase
    ) {
        self.fetchPlayListUseCase = fetchPlayListUseCase
        self.editPlayListOrderUseCase = editPlayListOrderUseCase
        self.deletePlayListUseCase = deletePlayListUseCase
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
            .map { _ in () }
            .bind(to: input.playListLoad)
            .disposed(by: disposeBag)

        input.playListLoad
            .flatMap { [weak self] () -> Observable<[PlayListEntity]> in
                guard let self = self else {
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
            .withLatestFrom(
                output.indexPathOfSelectedPlayLists,
                resultSelector: { indexPath, selectedPlayLists -> [IndexPath] in
                    if selectedPlayLists.contains(indexPath) {
                        guard let removeTargetIndex = selectedPlayLists.firstIndex(where: { $0 == indexPath })
                        else { return selectedPlayLists }
                        var newSelectedPlayLists = selectedPlayLists
                        newSelectedPlayLists.remove(at: removeTargetIndex)
                        return newSelectedPlayLists

                    } else {
                        return selectedPlayLists + [indexPath]
                    }
                }
            )
            .map { $0.sorted { $0 < $1 } }
            .bind(to: output.indexPathOfSelectedPlayLists)
            .disposed(by: disposeBag)

        input.itemMoved
            .withLatestFrom(output.dataSource) { ($0.sourceIndex, $0.destinationIndex, $1) }
            .withLatestFrom(output.indexPathOfSelectedPlayLists) { ($0.0, $0.1, $0.2, $1) }
            .map { sourceIndexPath, destinationIndexPath, dataSource, selectedPlayLists -> [MyPlayListSectionModel] in
                // 데이터 소스의 이동
                var newModel = dataSource.first?.items ?? []
                let temp = newModel[sourceIndexPath.row]
                newModel.remove(at: sourceIndexPath.row)
                newModel.insert(temp, at: destinationIndexPath.row)

                // 선택 된 플레이리스트 인덱스 패스 변경
                var newSelectedPlayLists: [IndexPath] = []
                for i in 0 ..< newModel.count {
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
            .map { flag, dataSource -> [IndexPath] in
                if flag {
                    let itemCount = (dataSource.first?.items ?? []).count
                    return Array(0 ..< itemCount).map { IndexPath(row: $0, section: 0) }
                } else {
                    return []
                }
            }
            .bind(to: output.indexPathOfSelectedPlayLists)
            .disposed(by: disposeBag)

        input.runEditing
            .withLatestFrom(output.dataSource)
            .map { $0.first?.items.map { $0.key } ?? [] }
            .filter { !$0.isEmpty }
            .do(onNext: { _ in
                output.indexPathOfSelectedPlayLists.accept([])
            })
            .filter { (ids: [String]) -> Bool in
                let beforeIds: [String] = output.backUpdataSource.value.first?.items.map { $0.key } ?? []
                let elementsEqual: Bool = beforeIds.elementsEqual(ids)
                DEBUG_LOG(elementsEqual ? "❌ 변경된 내용이 없습니다." : "✅ 리스트가 변경되었습니다.")
                return elementsEqual == false
            }
            .flatMap { [weak self] (ids: [String]) -> Observable<BaseEntity> in
                guard let self = self else {
                    return Observable.empty()
                }
                return self.editPlayListOrderUseCase.execute(ids: ids)
                    .catch { (error: Error) in
                        let wmError = error.asWMError
                        if wmError == .tokenExpired {
                            return Single<BaseEntity>.create { single in
                                single(.success(BaseEntity(status: 401, description: wmError.errorDescription ?? "")))
                                return Disposables.create()
                            }
                        } else {
                            return Single<BaseEntity>.create { single in
                                single(.success(BaseEntity(
                                    status: 400,
                                    description: "서버에서 문제가 발생하였습니다.\n잠시 후 다시 시도해주세요!"
                                )))
                                return Disposables.create()
                            }
                        }
                    }
                    .asObservable()
            }
            .filter { model in
                guard model.status == 200 else {
                    output.showToast.accept(model)
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
            .map { indexPathes, dataSource -> [SongEntity] in
                let songs = indexPathes.map {
                    return dataSource[$0.section].items[$0.row].songlist
                }.flatMap { $0 }
                return songs
            }
            .bind(to: output.willAddPlayList)
            .disposed(by: disposeBag)

        input.deletePlayList
            .withLatestFrom(output.indexPathOfSelectedPlayLists)
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .map { indexPathes, dataSource -> [String] in
                return indexPathes.map {
                    dataSource[$0.section].items[$0.row].key
                }
            }
            .filter { !$0.isEmpty }
            .flatMap { [weak self] ids -> Observable<BaseEntity> in
                guard let `self` = self else { return Observable.empty() }
                return self.deletePlayListUseCase.execute(ids: ids)
                    .catch { (error: Error) in
                        let wmError = error.asWMError
                        if wmError == .tokenExpired {
                            return Single<BaseEntity>.create { single in
                                single(.success(BaseEntity(status: 401, description: wmError.errorDescription ?? "")))
                                return Disposables.create()
                            }
                        } else {
                            return Single<BaseEntity>.create { single in
                                single(.success(BaseEntity(status: 400, description: "존재하지 않는 리스트입니다.")))
                                return Disposables.create()
                            }
                        }
                    }
                    .asObservable()
            }
            .do(onNext: { model in
                if model.status == 200 {
                    output.state.accept(EditState(isEditing: false, force: true))
                    output.indexPathOfSelectedPlayLists.accept([])
                    output.showToast.accept(BaseEntity(status: 200, description: "리스트가 삭제되었습니다."))
                } else {
                    output.state.accept(EditState(isEditing: false, force: true))
                    output.indexPathOfSelectedPlayLists.accept([])
                    output.showToast.accept(model)
                }
            })
            .map { _ in () }
            .bind(to: input.playListLoad)
            .disposed(by: disposeBag)

        output.indexPathOfSelectedPlayLists
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .map { selectedPlayLists, dataSource in
                var newModel = dataSource
                for i in 0 ..< newModel.count {
                    for j in 0 ..< newModel[i].items.count {
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

        return output
    }
}
