//
//  ArtistSongSortType.swift
//  ArtistDomainInterface
//
//  Created by KTH on 2024/03/07.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import Foundation

public enum ArtistSongSortType: String, Decodable {
    case new
    case popular
    case old

    public var display: String {
        switch self {
        case .new:
            return "최신순"
        case .popular:
            return "인기순"
        case .old:
            return "과거순"
        }
    }
}
