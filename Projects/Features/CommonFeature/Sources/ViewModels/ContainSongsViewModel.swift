//
//  ContainSongsViewModel.swift
//  CommonFeature
//
//  Created by yongbeomkwak on 2023/03/11.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import BaseFeature
import RxRelay
import DomainModule
import RxSwift

public final class ContainSongsViewModel:ViewModelType {

    
    
    var fetchPlayListUseCase:FetchPlayListUseCase!
    
    let disposeBag = DisposeBag()
    
    public struct Input {
        
        let newPlayListTap:PublishSubject<Void> = PublishSubject()
        let playListLoad:BehaviorRelay<Void> = BehaviorRelay(value: ())
        
    }
    
    public struct Output{
        let dataSource: BehaviorRelay<[PlayListEntity]> = BehaviorRelay(value: [])
    }
    
    init(fetchPlayListUseCase: FetchPlayListUseCase!) {
        self.fetchPlayListUseCase = fetchPlayListUseCase
        
        
    }
    
    public func transform(from input: Input) -> Output {
        
        let output = Output()
        
        
        input.playListLoad
            .flatMap({ [weak self] () -> Observable<[PlayListEntity]> in
                
                guard let self = self else{
                    return Observable.empty()
                }
                
                return self.fetchPlayListUseCase.execute()
                    .asObservable()
                    .catchAndReturn([])
            })
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)
        
        
        return output
    }
    
    
}
