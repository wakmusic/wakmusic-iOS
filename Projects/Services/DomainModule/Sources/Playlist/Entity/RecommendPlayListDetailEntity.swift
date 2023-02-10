//
//  RecommendPlayListEntity.swift
//  DomainModuleTests
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct RecommendPlayListDetailEntity: Equatable {
    public init(
        id: String,
        title: String,
        song_ids: [String],
        `public`:Bool
        
    ) {
        self.id = id
        self.title = title
        self.song_ids = song_ids
        self.public = `public`
   
    }
    
    public let id, title : String
    public let song_ids: [String]
    public let `public` : Bool
    
}
