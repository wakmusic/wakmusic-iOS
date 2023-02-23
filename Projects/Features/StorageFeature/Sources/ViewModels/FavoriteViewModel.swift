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

public final class FavoriteViewModel:ViewModelType {
    
    

    
    var disposeBag = DisposeBag()
    var fetchFavoriteSongsUseCase:FetchFavoriteSongsUseCase!
    var editFavoriteSongsOrderUseCase:EditFavoriteSongsOrderUseCase!

    public struct Input {
        let sourceIndexPath:BehaviorRelay<IndexPath> = BehaviorRelay(value: IndexPath(row: 0, section: 0))
        let destIndexPath:BehaviorRelay<IndexPath> = BehaviorRelay(value: IndexPath(row: 0, section: 0))
        let confirmEdit:PublishSubject<Void> = PublishSubject()
        let cancelEdit:PublishSubject<Void> = PublishSubject()
        
    }

    public struct Output {
        let isEditinglist:BehaviorRelay<Bool> = BehaviorRelay(value:false)
        let dataSource: BehaviorRelay<[FavoriteSongEntity]> = BehaviorRelay(value: [])
        let backUpdataSource:BehaviorRelay<[FavoriteSongEntity]> = BehaviorRelay(value: [])
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
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)
        
    
        input.confirmEdit.subscribe(onNext:{ 
            
            DEBUG_LOG(output.dataSource.value.map({$0.song.title}))
            
        })
            
//            .flatMap({ [weak self] () -> Observable<BaseEntity> in
//
//            guard let self = self else{
//                return Observable.empty()
//            }
//
//            return self.editFavoriteSongsOrderUseCase.execute(ids: output.dataSource.value.map({$0.song.id}))
//                .catch{ (error) in
//                    return Single<BaseEntity>.create { single in
//                        single(.success(BaseEntity(status: 0, description: error.asWMError.errorDescription ?? "")))
//                        return Disposables.create {}
//                    }
//                }
//                .asObservable()
//
//
//        })
//        .subscribe(onNext: {
//
//            guard $0.status == 200 else { return }
//
//            DEBUG_LOG("좋아요 순서 변경 성공")
//
//        })
        .disposed(by: disposeBag)
        
        
        
        input.cancelEdit.subscribe(onNext: {
            
            //되돌리기
            
        }).disposed(by: disposeBag)
        
        return output
    }
    
    
}
