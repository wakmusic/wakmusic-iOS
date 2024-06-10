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

public final class NoticePopupViewModel {
    let input = Input()
    let output = Output()
    private let disposeBag = DisposeBag()
    var fetchNoticeEntities: [FetchNoticeEntity]

    public struct Input {}

    public struct Output {
        let dataSource: BehaviorRelay<[FetchNoticeEntity.Image]> = BehaviorRelay(value: [])
        let ids: BehaviorRelay<[Int]> = BehaviorRelay(value: [])
    }

    public init(
        fetchNoticeEntities: [FetchNoticeEntity]
    ) {
        self.fetchNoticeEntities = fetchNoticeEntities

        let thumbnails: [FetchNoticeEntity.Image] = fetchNoticeEntities.map { $0.thumbnail }
        output.dataSource.accept(thumbnails)

        let ids: [Int] = self.fetchNoticeEntities.map { $0.id }
        output.ids.accept(ids)
    }
}
