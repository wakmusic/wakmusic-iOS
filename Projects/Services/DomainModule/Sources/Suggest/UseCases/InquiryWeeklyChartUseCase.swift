//
//  InquiryWeeklyChartUseCase.swift
//  DomainModule
//
//  Created by KTH on 2023/04/14.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DataMappingModule
import Foundation
import RxSwift

public protocol InquiryWeeklyChartUseCase {
    func execute(userID: String, content: String) -> Single<InquiryWeeklyChartEntity>
}
