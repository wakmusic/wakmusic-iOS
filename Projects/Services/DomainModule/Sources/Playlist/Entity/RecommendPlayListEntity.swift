//
//  RecommendPlayListEntity.swift
//  DomainModuleTests
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct RecommendPlayListEntity: Equatable {
    public init(
        id: String,
        title: String,
        `public`:Bool
    ) {
        self.id = id
        self.title = title
        self.public = `public`
   
    }
    
    public let id, title : String
    public let `public` : Bool
}
