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
import BaseFeature
import DomainModule
import Utility
import CommonFeature

public final class FavoriteViewModel:ViewModelType {
    
    

    
    var disposeBag = DisposeBag()
    var fetchFavoriteSongsUseCase:FetchFavoriteSongsUseCase!
    var editFavoriteSongsOrderUseCase:EditFavoriteSongsOrderUseCase!

    public struct Input {
        let sourceIndexPath:BehaviorRelay<IndexPath> = BehaviorRelay(value: IndexPath(row: 0, section: 0))
        let destIndexPath:BehaviorRelay<IndexPath> = BehaviorRelay(value: IndexPath(row: 0, section: 0))
        let cancelEdit:PublishSubject<Void> = PublishSubject()
        let runEditing:PublishSubject<Void> = PublishSubject()
        let showConfirmModal:PublishSubject<Void> = PublishSubject()
        let showErrorToast:PublishRelay<String> = PublishRelay()
        
    }

    public struct Output {
        let state:BehaviorRelay<EditState> = BehaviorRelay(value: EditState(isEditing: false, force: true))
        let dataSource: BehaviorRelay<[FavoriteSectionModel]> = BehaviorRelay(value: [])
        let backUpdataSource:BehaviorRelay<[FavoriteSectionModel]> = BehaviorRelay(value: [])
    }

    init(fetchFavoriteSongsUseCase:FetchFavoriteSongsUseCase,editFavoriteSongsOrderUseCase:EditFavoriteSongsOrderUseCase) {
        
        DEBUG_LOG("✅ FavoriteViewModel 생성")
        self.fetchFavoriteSongsUseCase = fetchFavoriteSongsUseCase
        self.editFavoriteSongsOrderUseCase = editFavoriteSongsOrderUseCase
        
        
        
        
    }
    
    public func transform(from input: Input) -> Output {
        
        var output = Output()
        
        fetchFavoriteSongsUseCase.execute()

            .catchAndReturn([])
            .asObservable()
            .map { [FavoriteSectionModel(model: 0, items: $0)] }
            .bind(to: output.dataSource,output.backUpdataSource)
            .disposed(by: disposeBag)
        
        
        input.runEditing.withLatestFrom(output.dataSource)
            .map { $0.first?.items.map { $0.song.id } ?? [] }
            .filter({!$0.isEmpty})
            .flatMap({[weak self] (ids:[String])  -> Observable<BaseEntity> in
                
                guard let self = self else{
                    return Observable.empty()
                }
                
                return self.editFavoriteSongsOrderUseCase.execute(ids: ids)
                    .asObservable()
            }).subscribe(onNext: { [weak self] in
                
                guard let self = self else{
                    return
                }
                
                
                if $0.status != 200 {
                    // 에러 처리
                    
                    input.showErrorToast.accept($0.description)
                    
                    return
                }
                output.backUpdataSource.accept(output.dataSource.value)
            })
            .disposed(by: disposeBag)
    
        
    
        input.cancelEdit
            .withLatestFrom(output.backUpdataSource)
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)
        
        

        
        return output
    }
    
    
}
