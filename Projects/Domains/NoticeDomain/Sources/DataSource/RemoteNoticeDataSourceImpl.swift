//
//  RemoteNoticeDataSourceImpl.swift
//  NetworkModule
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import BaseDomain
import Foundation
import NoticeDomainInterface
import RxSwift

public final class RemoteNoticeDataSourceImpl: BaseRemoteDataSource<NoticeAPI>, RemoteNoticeDataSource {
    public func fetchNoticeCategories() -> Single<FetchNoticeCategoriesEntity> {
        request(.fetchNoticeCategories)
            .map(FetchNoticeCategoriesResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func fetchNoticePopup() -> Single<[FetchNoticeEntity]> {
        request(.fetchNoticePopup)
            .map([FetchNoticeResponseDTO].self)
            .map { $0.map { $0.toDomain() } }
    }

    public func fetchNoticeAll() -> Single<[FetchNoticeEntity]> {
        request(.fetchNoticeAll)
            .map([FetchNoticeResponseDTO].self)
            .map { $0.map { $0.toDomain() } }
    }

    public func fetchNoticeIDList() -> Single<FetchNoticeIDListEntity> {
        request(.fetchNoticeIDList)
            .map(FetchNoticeIDListDTO.self)
            .map { $0.toDomain() }
    }
}
