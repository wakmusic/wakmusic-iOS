//
//  NoticePopupViewModel.swift
//  CommonFeature
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import BaseFeature
import Foundation
import NoticeDomainInterface
import RxCocoa
import RxSwift
import Utility

public class NoticePopupViewModel {
    let input = Input()
    let output = Output()
    var disposeBag = DisposeBag()
    var fetchNoticeEntities: [FetchNoticeEntity]

    public struct Input {}

    public struct Output {
        var dataSource: BehaviorRelay<[String]> = BehaviorRelay(value: [])
        var ids: BehaviorRelay<[Int]> = BehaviorRelay(value: [])
    }

    public init(
        fetchNoticeEntities: [FetchNoticeEntity]
    ) {
        self.fetchNoticeEntities = fetchNoticeEntities

        let images: [String] = self.fetchNoticeEntities.map { $0.thumbnail ?? "" }.filter { !$0.isEmpty }
        output.dataSource.accept(images)

        let ids: [Int] = self.fetchNoticeEntities.map { $0.id }
        output.ids.accept(ids)
    }
}
