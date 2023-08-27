//
//  PostPlaybackLogEntity.swift
//  DomainModuleTests
//
//  Created by KTH on 2023/08/27.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct PostPlaybackLogEntity: Equatable {
    public init(
        id: String,
        title: String,
        artist: String
    ) {
        self.id = id
        self.title = title
        self.artist = artist
    }
    
    public let id, title, artist: String
    
    public static func == (lhs: PostPlaybackLogEntity, rhs:  PostPlaybackLogEntity) -> Bool {
        lhs.id == rhs.id
    }
}
