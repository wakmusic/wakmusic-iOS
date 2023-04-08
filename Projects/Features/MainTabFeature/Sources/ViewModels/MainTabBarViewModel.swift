//
//  MainTabBarViewModel.swift
//  MainTabFeature
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import DomainModule
import DataMappingModule
import Utility

public class MainTabBarViewModel {
    
    var input = Input()
    var output = Output()
    var disposeBag = DisposeBag()
    
    var fetchNoticeUseCase: FetchNoticeUseCase
    
    public struct Input {
    }

    public struct Output {
        var dataSource: BehaviorRelay<[FetchNoticeEntity]> = BehaviorRelay(value: [])
    }
    
    public init(
        fetchNoticeUseCase: any FetchNoticeUseCase
    ){
        self.fetchNoticeUseCase = fetchNoticeUseCase
        
        self.fetchNoticeUseCase.execute(type: .currently)
            .catchAndReturn([])
            .asObservable()
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)
    }
}
