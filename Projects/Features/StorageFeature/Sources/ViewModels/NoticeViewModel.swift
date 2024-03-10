//
//  NoticeViewModel.swift
//  StorageFeature
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import BaseFeature
import Foundation
import RxCocoa
import RxSwift
import Utility
import NoticeDomainInterface

public class NoticeViewModel {
    let input = Input()
    let output = Output()
    var disposeBag = DisposeBag()
    var fetchNoticeUseCase: FetchNoticeUseCase

    public struct Input {}

    public struct Output {
        var dataSource: BehaviorRelay<[FetchNoticeEntity]> = BehaviorRelay(value: [])
    }

    public init(
        fetchNoticeUseCase: any FetchNoticeUseCase
    ) {
        self.fetchNoticeUseCase = fetchNoticeUseCase

        self.fetchNoticeUseCase.execute(type: .all)
            .catchAndReturn([])
            .asObservable()
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)
    }
}
