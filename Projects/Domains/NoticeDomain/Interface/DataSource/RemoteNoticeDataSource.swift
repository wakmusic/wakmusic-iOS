//
//  RemoteNoticeDataSource.swift
//  NetworkModule
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift

public protocol RemoteNoticeDataSource {
    func fetchNoticeCategories() -> Single<FetchNoticeCategoriesEntity>
    func fetchNoticePopup() -> Single<[FetchNoticeEntity]>
    func fetchNoticeAll() -> Single<[FetchNoticeEntity]>
    func fetchNoticeIDList() -> Single<FetchNoticeIDListEntity>
}
