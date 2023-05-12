//
//  ReportBugUseCaseImpl.swift
//  DataModuleTests
//
//  Created by KTH on 2023/04/14.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import DataMappingModule
import DomainModule
import ErrorModule

public struct ReportBugUseCaseImpl: ReportBugUseCase {
    private let suggestRepository: any SuggestRepository

    public init(
        suggestRepository: SuggestRepository
    ) {
        self.suggestRepository = suggestRepository
    }
    public func execute(userID: String, nickname: String, attaches: [String], content: String) -> Single<ReportBugEntity> {
        suggestRepository.reportBug(userID: userID, nickname: nickname, attaches: attaches, content: content)
    }
}
