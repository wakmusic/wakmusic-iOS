//
//  ArtistType.swift
//  DataMappingModule
//
//  Created by KTH on 2023/02/01.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public enum ArtistSongSortType: String, Codable {
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
