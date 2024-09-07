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
    private let disposeBag = DisposeBag()
    private let noticeEntities: [FetchNoticeEntity]

    public init(
        noticeEntities: [FetchNoticeEntity]
    ) {
        self.noticeEntities = noticeEntities
    }

    public struct Input {
        let fetchFilteredNotice: PublishSubject<Void> = PublishSubject()
        let didTapPopup: PublishSubject<IndexPath> = PublishSubject()
    }

    public struct Output {
        let originDataSource: BehaviorRelay<[FetchNoticeEntity]> = BehaviorRelay(value: [])
        let thumbnailDataSource: BehaviorRelay<[FetchNoticeEntity.Image]> = BehaviorRelay(value: [])
        let dismissAndCallDelegate: PublishSubject<FetchNoticeEntity> = PublishSubject()
    }

    public func transform(from input: Input) -> Output {
        let output = Output()
        let noticeEntities: [FetchNoticeEntity] = self.noticeEntities

        input.fetchFilteredNotice
            .bind {
                output.thumbnailDataSource.accept(
                    noticeEntities.map { $0.thumbnail }.filter { !$0.url.isEmpty }
                )
                output.originDataSource.accept(noticeEntities)
            }
            .disposed(by: disposeBag)

        input.didTapPopup
            .withLatestFrom(output.originDataSource) { ($0, $1) }
            .map { $0.1[$0.0.item] }
            .bind(to: output.dismissAndCallDelegate)
            .disposed(by: disposeBag)

        return output
    }
}
