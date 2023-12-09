//
//  RemoteNoticeDataSource.swift
//  NetworkModule
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DataMappingModule
import ErrorModule
import DomainModule
import RxSwift
import Foundation

public protocol RemoteNoticeDataSource {
    func fetchNotice(type: NoticeType) -> Single<[FetchNoticeEntity]>
    func fetchNoticeCategories() -> Single<FetchNoticeCategoriesEntity>
}
