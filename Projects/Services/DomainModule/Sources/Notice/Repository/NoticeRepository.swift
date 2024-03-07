//
//  NoticeRepository.swift
//  DomainModuleTests
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DataMappingModule
import ErrorModule
import Foundation
import RxSwift

public protocol NoticeRepository {
    func fetchNotice(type: NoticeType) -> Single<[FetchNoticeEntity]>
    func fetchNoticeCategories() -> Single<FetchNoticeCategoriesEntity>
}
