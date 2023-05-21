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
        title: String,
        songs: [SongEntity],
        `public`:Bool,
        key:String,
        image:String,
        image_square_version:Int,
        image_round_version:Int,
        version:Int
        
    ) {
        self.title = title
        self.songs = songs
        self.public = `public`
        self.key = key
        self.image = image
        self.image_round_version = image_round_version
        self.image_square_version = image_square_version
        self.version = version
   
    }
    
    public let title : String
    public let songs: [SongEntity]
    public let `public` : Bool
    public let key,image: String
    public let image_round_version,image_square_version,version :Int
    
}
