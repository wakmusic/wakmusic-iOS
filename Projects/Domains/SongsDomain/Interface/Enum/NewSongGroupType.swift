//
//  NewSongGroupType.swift
//  DataMappingModule
//
//  Created by KTH on 2023/02/20.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public enum NewSongGroupType: CaseIterable {
    case all
    case woowakgood
    case isedol
    case gomem
    case academy

    public var apiKey: String {
        switch self {
        case .all:
            return "all"
        case .woowakgood:
            return "woowakgood"
        case .isedol:
            return "isedol"
        case .gomem:
            return "gomem"
        case .academy:
            return "academy"
        }
    }

    public var display: String {
        switch self {
        case .all:
            return "전체"
        case .woowakgood:
            return "우왁굳"
        case .isedol:
            return "이세돌"
        case .gomem:
            return "클래식"
        case .academy:
            return "아카데미"
        }
    }
}
