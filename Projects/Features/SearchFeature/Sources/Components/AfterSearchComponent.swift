//
//  BeforeSearchComponent.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import CommonFeature
import Foundation
import NeedleFoundation
import SongsDomainInterface

public protocol AfterSearchDependency: Dependency {
    var afterSearchContentComponent: AfterSearchContentComponent { get }
    var fetchSearchSongUseCase: any FetchSearchSongUseCase { get }
    var containSongsComponent: ContainSongsComponent { get }
}

public final class AfterSearchComponent: Component<AfterSearchDependency> {
    public func makeView() -> AfterSearchViewController {
        return AfterSearchViewController.viewController(
            afterSearchContentComponent: dependency.afterSearchContentComponent,
            containSongsComponent: dependency.containSongsComponent,
            viewModel: .init(fetchSearchSongUseCase: dependency.fetchSearchSongUseCase)
        )
    }
}
