//
//  NoticeRepositoryImpl.swift
//  DataModule
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import NoticeDomainInterface
import RxSwift

public final class NoticeRepositoryImpl: NoticeRepository {
    private let remoteNoticeDataSource: any RemoteNoticeDataSource

    public init(
        remoteNoticeDataSource: RemoteNoticeDataSource
    ) {
        self.remoteNoticeDataSource = remoteNoticeDataSource
    }

    public func fetchNotice(type: NoticeType) -> Single<[FetchNoticeEntity]> {
        remoteNoticeDataSource.fetchNotice(type: type)
    }

    public func fetchNoticeCategories() -> Single<FetchNoticeCategoriesEntity> {
        remoteNoticeDataSource.fetchNoticeCategories()
    }
}
