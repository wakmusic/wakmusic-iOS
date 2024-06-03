//
//  LyricDecoratingComponent.swift
//  LyricHighlightingFeature
//
//  Created by KTH on 6/3/24.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import Foundation
import NeedleFoundation

public protocol LyricDecoratingDependency: Dependency {
}

public final class LyricDecoratingComponent: Component<LyricDecoratingDependency> {
    public func makeView() -> LyricDecoratingViewController {
        return LyricDecoratingViewController()
    }
}
