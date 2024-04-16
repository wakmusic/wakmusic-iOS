//
//  BeforeSearchComponent.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import BaseFeature
import Foundation
import NeedleFoundation
import PlayListDomainInterface
import PlaylistFeatureInterface

public protocol BeforeSearchDependency: Dependency {
    var playlistFactory: any PlaylistFactory { get }
    var fetchRecommendPlayListUseCase: any FetchRecommendPlayListUseCase { get }
}

public final class BeforeSearchComponent: Component<BeforeSearchDependency> {
    public func makeView() -> BeforeSearchContentViewController {
        return BeforeSearchContentViewController.viewController(
            playlistFactory: dependency.playlistFactory,
            viewModel: .init(fetchRecommendPlayListUseCase: dependency.fetchRecommendPlayListUseCase)
        )
    }
}
