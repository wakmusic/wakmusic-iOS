//
//  FetchNoticeTransfer.swift
//  NetworkModuleTests
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import DataMappingModule
import DomainModule
import Utility

public extension FetchNoticeResponseDTO {
    func toDomain() -> FetchNoticeEntity {
        FetchNoticeEntity(
            id: id,
            category: category?.category ?? "",
            title: title,
            thumbnail: thumbnail,
            content: content,
            images: images,
            createAt: createAt,
            startAt: startAt,
            endAt: endAt
        )
    }
}
