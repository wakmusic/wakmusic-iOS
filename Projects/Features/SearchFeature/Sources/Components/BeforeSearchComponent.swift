//
//  BeforeSearchComponent.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import CommonFeature
import PlayListDomainInterface
import Foundation
import NeedleFoundation

public protocol BeforeSearchDependency: Dependency {
    var playListDetailComponent: PlayListDetailComponent { get }
    var fetchRecommendPlayListUseCase: any FetchRecommendPlayListUseCase { get }
}

public final class BeforeSearchComponent: Component<BeforeSearchDependency> {
    public func makeView() -> BeforeSearchContentViewController {
        return BeforeSearchContentViewController.viewController(
            recommendPlayListDetailComponent: dependency.playListDetailComponent,
            viewModel: .init(fetchRecommendPlayListUseCase: dependency.fetchRecommendPlayListUseCase)
        )
    }
}
