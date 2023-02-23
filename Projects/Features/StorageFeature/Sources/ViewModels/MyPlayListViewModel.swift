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

public final class MyPlayListViewModel:ViewModelType {
    
    

    var disposeBag = DisposeBag()
    var fetchPlayListUseCase:FetchPlayListUseCase!
    
    public struct Input {
        let sourceIndexPath:BehaviorRelay<IndexPath> = BehaviorRelay(value: IndexPath(row: 0, section: 0))
        let destIndexPath:BehaviorRelay<IndexPath> = BehaviorRelay(value: IndexPath(row: 0, section: 0))
        
        let playListLoad:BehaviorRelay<Void> = BehaviorRelay(value: ())
        
    }

    public struct Output {
        let state:BehaviorRelay<EditState> = BehaviorRelay(value: EditState(isEditing: false, force: false))
        let dataSource: BehaviorRelay<[PlayListEntity]> = BehaviorRelay(value: [])
    }

    init(fetchPlayListUseCase:FetchPlayListUseCase) {
        
        self.fetchPlayListUseCase = fetchPlayListUseCase
        DEBUG_LOG("✅ MyPlayListViewModel 생성")
        
        
        
    }
    
    public func transform(from input: Input) -> Output {
        
        var output = Output()
        
        input.playListLoad
            .flatMap({ [weak self] () -> Observable<[PlayListEntity]> in
                
                guard let self = self else{
                    return Observable.empty()
                }
                
                return self.fetchPlayListUseCase.execute()
                    .asObservable()
            })
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)
        
      
        
        
        
        
        return output
        
    }
    
    
}
