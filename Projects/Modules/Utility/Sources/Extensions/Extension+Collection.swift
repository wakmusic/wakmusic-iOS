//
//  Extension+Collection.swift
//  Utility
//
//  Created by YoungK on 2023/04/13.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public extension Collection {
    subscript(safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
