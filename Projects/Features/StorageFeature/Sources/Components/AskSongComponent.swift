//
//  SearchComponent.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import NeedleFoundation
import DomainModule

public protocol AskSongDependency: Dependency {
    var modifySongUseCase: ModifySongUseCase { get }
}

public final class AskSongComponent: Component<AskSongDependency> {
    public func makeView(type:SongRequestType) -> AskSongViewController {
        return AskSongViewController.viewController(viewModel:
                .init(type: type,
                      modifySongUseCase: dependency.modifySongUseCase)
        )
    }
}
