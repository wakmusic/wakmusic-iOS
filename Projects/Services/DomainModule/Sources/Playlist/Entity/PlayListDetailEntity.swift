//
//  RecommendPlayListEntity.swift
//  DomainModuleTests
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct PlayListDetailEntity: Equatable {
    public init(
        id: String,
        title: String,
        songs: [SongEntity],
        `public`:Bool,
        key:String,
        creator_id:String,
        image:String,
        image_square_version:Int,
        image_version:Int
        
        
    ) {
        self.id = id
        self.title = title
        self.songs = songs
        self.public = `public`
        self.key = key
        self.creator_id = creator_id
        self.image = image
        self.image_version = image_version
        self.image_square_version = image_square_version
   
    }
    
    public let id, title : String
    public let songs: [SongEntity]
    public let `public` : Bool
    public let key,creator_id,image: String
    public let image_version,image_square_version :Int
    
}
