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
        
    }

    public struct Output {
        let isEditinglist:BehaviorRelay<Bool> = BehaviorRelay(value:false)
        let dataSource: BehaviorRelay<[PlayListDTO]> = BehaviorRelay(value: [])
    }

    init(fetchSubPlayListUseCase:FetchSubPlayListUseCase) {
        
        self.fetchSubPlayListUseCase = fetchSubPlayListUseCase
        print("✅ PlayListDetailViewModel 생성")
        
        self.fetchSubPlayListUseCase.execute()
            .subscribe(onSuccess: {DEBUG_LOG($0)})
            .disposed(by: disposeBag)
        
    }
    
    public func transform(from input: Input) -> Output {
        
        return Output()
        
    }
    
    
}
