//
//  InquiryWeeklyChartEntity.swift
//  DomainModule
//
//  Created by KTH on 2023/04/14.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct InquiryWeeklyChartEntity: Codable {
    public init (
        status: Int?,
        message: String?
    ) {
        self.status = status
        self.message = message
    }

    public let status: Int?
    public let message: String?
}
