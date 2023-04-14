//
//  ReportBugTransfer.swift
//  NetworkModule
//
//  Created by KTH on 2023/04/14.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import DataMappingModule
import DomainModule

public extension ReportBugResponseDTO {
    func toDomain() -> ReportBugEntity {
        ReportBugEntity(
            status: status,
            message: message
        )
    }
}
