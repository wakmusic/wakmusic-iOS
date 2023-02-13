//
//  BeforeSearchComponent.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import NeedleFoundation
import DomainModule
import CommonFeature

public protocol AfterSearchComponentDependency: Dependency {
    var fetchSearchSongUseCase: any FetchSearchSongUseCase {get}
}

public final class AfterSearchContentComponent: Component<AfterSearchComponentDependency> {
    public func makeView(type:SectionType) -> AfterSearchContentViewController {
        return AfterSearchContentViewController.viewController(viewModel:.init(type: type, fetchSearchSongUseCase: dependency.fetchSearchSongUseCase))
        
    }
}
