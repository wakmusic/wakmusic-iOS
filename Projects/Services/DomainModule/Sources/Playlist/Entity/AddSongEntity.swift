//
//  AddSongEntity.swift
//  DomainModule
//
//  Created by yongbeomkwak on 2023/03/14.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation


public struct AddSongEntity: Equatable {
    
    public init(
        status: Int,
        added_songs_length: Int,
        duplicated: Bool,
        description: String
    ) {
        self.status = status
        self.added_songs_length = added_songs_length
        self.duplicated = duplicated
        self.description = description
    }

    
    public let status: Int
    public let added_songs_length: Int
    public let duplicated: Bool
    public let description:String
}
