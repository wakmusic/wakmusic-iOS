//
//  ReportBugUseCase.swift
//  DomainModule
//
//  Created by KTH on 2023/04/14.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import DataMappingModule

public protocol ReportBugUseCase {
    func execute(userID: String, nickname: String, attaches: [Data], content: String) -> Single<ReportBugEntity>
}
