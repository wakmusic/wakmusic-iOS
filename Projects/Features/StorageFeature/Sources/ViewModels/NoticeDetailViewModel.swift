//
//  NoticeDetailViewModel.swift
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

public class NoticeDetailViewModel {
    
    let input = Input()
    let output = Output()
    var disposeBag = DisposeBag()
    var model: FetchNoticeEntity
    
    deinit {
        DEBUG_LOG("❌ \(Self.self) Deinit")
    }

    public struct Input {
    }

    public struct Output {
        var dataSource: BehaviorRelay<[NoticeDetailSectionModel]> = BehaviorRelay(value: [])
    }
    
    public init(
        model: FetchNoticeEntity
    ){
        self.model = model
        let sectionModel = [NoticeDetailSectionModel(model: self.model,
                                                     items: self.model.images)]
        output.dataSource.accept(sectionModel)
    }
}
