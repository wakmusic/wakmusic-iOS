//
//  File.swift
//  WaktaverseMusic
//
//  Created by yongbeomkwak on 4/16/24.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import Foundation
import BaseFeature
import BaseFeatureInterface

public extension AppComponent {
    var multiPurposePopUpFactory: any MultiPurposePopUpFactory {
        MultiPurposePopUpComponent(parent: self)
    }
}
