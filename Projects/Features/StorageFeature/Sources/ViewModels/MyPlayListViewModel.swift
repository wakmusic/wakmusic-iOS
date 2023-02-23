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
    var fetchSubPlayListUseCase:FetchSubPlayListUseCase!
    
    public struct Input {
        let sourceIndexPath:BehaviorRelay<IndexPath> = BehaviorRelay(value: IndexPath(row: 0, section: 0))
        let destIndexPath:BehaviorRelay<IndexPath> = BehaviorRelay(value: IndexPath(row: 0, section: 0))
        
        let playListLoad:BehaviorRelay<Void> = BehaviorRelay(value: ())
        
    }

    public struct Output {
        let isEditinglist:BehaviorRelay<Bool> = BehaviorRelay(value:false)
        let dataSource: BehaviorRelay<[SubPlayListEntity]> = BehaviorRelay(value: [])
    }

    init(fetchSubPlayListUseCase:FetchSubPlayListUseCase) {
        
        self.fetchSubPlayListUseCase = fetchSubPlayListUseCase
        DEBUG_LOG("✅ MyPlayListViewModel 생성")
        
        
        
    }
    
    public func transform(from input: Input) -> Output {
        
        var output = Output()
        
        input.playListLoad
            .flatMap({ [weak self] () -> Observable<[SubPlayListEntity]> in
                
                guard let self = self else{
                    return Observable.empty()
                }
                
                return self.fetchSubPlayListUseCase.execute()
                    .asObservable()
            })
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)
        
      
        
        
        
        
        return output
        
    }
    
    
}
