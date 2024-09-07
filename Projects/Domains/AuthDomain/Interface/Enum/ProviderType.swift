//
//  SearchType.swift
//  DataMappingModule
//
//  Created by yongbeomkwak on 2023/02/07.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public enum ProviderType: String {
    case naver
    case apple
    case google

    public var display: String {
        switch self {
        case .naver:
            return "naver"
        case .apple:
            return "apple"
        case .google:
            return "google"
        }
    }
}
