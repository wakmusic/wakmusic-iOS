//
//  FavoriteViewModel.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/27.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

import Foundation
import RxSwift
import RxRelay
import BaseFeature
import DomainModule

public final class FavoriteViewModel:ViewModelType {
    
    

    
    var disposeBag = DisposeBag()
    var fetchFavoriteSongsUseCase:FetchFavoriteSongsUseCase!

    public struct Input {
        let sourceIndexPath:BehaviorRelay<IndexPath> = BehaviorRelay(value: IndexPath(row: 0, section: 0))
        let destIndexPath:BehaviorRelay<IndexPath> = BehaviorRelay(value: IndexPath(row: 0, section: 0))
        
    }

    public struct Output {
        let isEditinglist:BehaviorRelay<Bool> = BehaviorRelay(value:false)
        let dataSource: BehaviorRelay<[FavoriteSongEntity]> = BehaviorRelay(value: [])
    }

    init(fetchFavoriteSongsUseCase:FetchFavoriteSongsUseCase) {
        
        print("✅ PlayListDetailViewModel 생성")
        self.fetchFavoriteSongsUseCase = fetchFavoriteSongsUseCase
        
        
        
        
    }
    
    public func transform(from input: Input) -> Output {
        
        var output = Output()
        
        fetchFavoriteSongsUseCase.execute()
            .catchAndReturn([])
            .asObservable()
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)
        
    
        return output
    }
    
    
}
