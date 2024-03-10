//
//  RemoteNoticeDataSourceImpl.swift
//  NetworkModule
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import BaseDomain
import NoticeDomainInterface

public final class RemoteNoticeDataSourceImpl: BaseRemoteDataSource<NoticeAPI>, RemoteNoticeDataSource {
    public func fetchNotice(type: NoticeType) -> Single<[FetchNoticeEntity]> {
        request(.fetchNotice(type: type))
            .map([FetchNoticeResponseDTO].self)
            .map { $0.map { $0.toDomain() }}
    }

    public func fetchNoticeCategories() -> Single<FetchNoticeCategoriesEntity> {
        request(.fetchNoticeCategories)
            .map(FetchNoticeCategoriesResponseDTO.self)
            .map { $0.toDomain() }
    }
}
