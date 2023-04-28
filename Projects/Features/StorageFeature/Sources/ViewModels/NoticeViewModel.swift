//
//  NoticeViewModel.swift
//  StorageFeature
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import BaseFeature
import DomainModule
import DataMappingModule
import Utility

public class NoticeViewModel {
    
    let input = Input()
    let output = Output()
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
        
        self.fetchNoticeUseCase.execute(type: .all)
            .catchAndReturn([])
            .asObservable()
            .map { $0.sorted { $0.id > $1.id } }
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)
    }
}
