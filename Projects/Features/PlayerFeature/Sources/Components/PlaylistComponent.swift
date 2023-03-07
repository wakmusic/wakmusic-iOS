//
//  PlaylistComponent.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/02/28.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import DomainModule
import NeedleFoundation

public protocol PlaylistDependency: Dependency {
    
}

public final class PlaylistComponent: Component<PlaylistDependency> {
    public func makeView() -> PlaylistViewController {
        return PlaylistViewController(viewModel: .init())
    }
}
