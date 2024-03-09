//
//  ReportBugTransfer.swift
//  NetworkModule
//
//  Created by KTH on 2023/04/14.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DataMappingModule
import DomainModule
import Foundation

public extension ReportBugResponseDTO {
    func toDomain() -> ReportBugEntity {
        ReportBugEntity(
            status: status,
            message: message
        )
    }
}
