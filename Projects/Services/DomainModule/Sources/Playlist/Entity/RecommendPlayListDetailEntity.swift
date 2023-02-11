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
        songs: [SongEntity],
        `public`:Bool
        
    ) {
        self.id = id
        self.title = title
        self.songs = songs
        self.public = `public`
   
    }
    
    public let id, title : String
    public let songs: [SongEntity]
    public let `public` : Bool
    
}
