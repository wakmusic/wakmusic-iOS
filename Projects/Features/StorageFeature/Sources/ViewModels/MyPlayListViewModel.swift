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
    var fetchPlayListUseCase:FetchPlayListUseCase!
    var editPlayListOrderUseCase:EditPlayListOrderUseCase!
    var disposeBag = DisposeBag()

    public struct Input {
        let playListLoad: BehaviorRelay<Void> = BehaviorRelay(value: ())
        let itemMoved: PublishSubject<ItemMovedEvent> = PublishSubject()
        let cancelEdit: PublishSubject<Void> = PublishSubject()
        let runEditing: PublishSubject<Void> = PublishSubject()
    }

    public struct Output {
        let state: BehaviorRelay<EditState> = BehaviorRelay(value: EditState(isEditing: false, force: true))
        let dataSource: BehaviorRelay<[MyPlayListSectionModel]> = BehaviorRelay(value: [])
        let backUpdataSource: BehaviorRelay<[MyPlayListSectionModel]> = BehaviorRelay(value: [])
        let showErrorToast: PublishRelay<String> = PublishRelay()
    }

    init(
        fetchPlayListUseCase: FetchPlayListUseCase,
        editPlayListOrderUseCase: EditPlayListOrderUseCase
    ) {
        self.fetchPlayListUseCase = fetchPlayListUseCase
        self.editPlayListOrderUseCase = editPlayListOrderUseCase
        DEBUG_LOG("✅ \(Self.self) 생성")
    }
    
    public func transform(from input: Input) -> Output {
        let output = Output()
        
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
        
        input.itemMoved
            .withLatestFrom(output.dataSource) { ($0.sourceIndex, $0.destinationIndex, $1) }
            .map { (sourceIndexPath, destinationIndexPath, dataSource) -> [MyPlayListSectionModel] in
                var newModel = dataSource.first?.items ?? []
                let temp = newModel[sourceIndexPath.row]
                
                newModel.remove(at: sourceIndexPath.row)
                newModel.insert(temp, at: destinationIndexPath.row)

                let sectionModel = [MyPlayListSectionModel(model: 0, items: newModel)]
                return sectionModel
            }
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)
        
        input.runEditing.withLatestFrom(output.dataSource)
            .map { $0.first?.items.map { $0.key } ?? [] }
            .filter{ !$0.isEmpty }
            .flatMap{ [weak self] (ids: [String]) -> Observable<BaseEntity> in
                guard let self = self else{
                    return Observable.empty()
                }
                return self.editPlayListOrderUseCase.execute(ids: ids).asObservable()
            }
            .filter{ (model) in
                guard model.status == 200 else {
                    output.showErrorToast.accept(model.description)
                    return false
                }
                return true
            }
            .withLatestFrom(output.dataSource)
            .bind(to: output.backUpdataSource)
            .disposed(by: disposeBag)
        
        input.cancelEdit
            .withLatestFrom(output.backUpdataSource)
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)
        
        return output
    }
}
