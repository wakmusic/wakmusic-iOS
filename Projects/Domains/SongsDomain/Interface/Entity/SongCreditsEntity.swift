//
//  SongCreditsEntity.swift
//  SongsDomain
//
//  Created by KTH on 5/14/24.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import Foundation

public struct SongCreditsEntity {
    public init(
        type: String,
        names: [Credit]
    ) {
        self.type = type
        self.names = names
    }

    public init(
        type: String,
        names: [String]
    ) {
        self.type = type
        self.names = names.map {
            Credit(name: $0, isArtist: false, artistID: nil)
        }
    }

    public let type: String
    public let names: [Credit]

    public struct Credit {
        public let name: String
        public let isArtist: Bool
        public let artistID: String?

        public init(name: String, isArtist: Bool, artistID: String?) {
            self.name = name
            self.isArtist = isArtist
            self.artistID = artistID
        }
    }
}
