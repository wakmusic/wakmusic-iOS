//
//  RemoteNoticeDataSourceImpl.swift
//  NetworkModule
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import APIKit
import RxSwift
import DataMappingModule
import DomainModule
import ErrorModule
import Foundation

public final class RemoteNoticeDataSourceImpl: BaseRemoteDataSource<NoticeAPI>, RemoteNoticeDataSource {
    public func fetchNotice(type: NoticeType) -> Single<[FetchNoticeEntity]> {
        request(.fetchNotice(type: type))
            .map([FetchNoticeResponseDTO].self)
            .map { $0.map { $0.toDomain() }}
    }
    
    public func fetchNoticeCategories() -> Single<[FetchNoticeCategoriesEntity]> {
        request(.fetchNoticeCategories)
            .map([String].self)
            .map{ $0.map{ FetchNoticeCategoriesEntity(id: $0) }}
    }
}
