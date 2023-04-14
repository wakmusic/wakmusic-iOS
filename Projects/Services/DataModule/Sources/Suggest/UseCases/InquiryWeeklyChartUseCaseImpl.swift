//
//  InquiryWeeklyChartUseCaseImpl.swift
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

public struct InquiryWeeklyChartUseCaseImpl: InquiryWeeklyChartUseCase {
    private let suggestRepository: any SuggestRepository

    public init(
        suggestRepository: SuggestRepository
    ) {
        self.suggestRepository = suggestRepository
    }
    public func execute(userID: String, content: String) -> Single<InquiryWeeklyChartEntity> {
        suggestRepository.inquiryWeeklyChart(userID: userID, content: content)
    }
}
