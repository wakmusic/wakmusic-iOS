//
//  FetchNoticeUseCase.swift
//  DomainModuleTests
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift

public protocol FetchNoticeUseCase {
    func execute(type: NoticeType) -> Single<[FetchNoticeEntity]>
}
