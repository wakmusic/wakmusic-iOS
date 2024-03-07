//
//  ReportBugUseCase.swift
//  DomainModule
//
//  Created by KTH on 2023/04/14.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DataMappingModule
import Foundation
import RxSwift

public protocol ReportBugUseCase {
    func execute(userID: String, nickname: String, attaches: [String], content: String) -> Single<ReportBugEntity>
}
