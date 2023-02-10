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

public protocol BeforeSearchDependency: Dependency {
    var fetchRecommendPlayListUseCase: any FetchRecommendPlayListUseCase {get}
  
    
}

public final class BeforeSearchComponent: Component<BeforeSearchDependency> {
    public func makeView() -> BeforeSearchContentViewController {
        return BeforeSearchContentViewController.viewController(viewModel: .init(fetchRecommendPlayListUseCase: dependency.fetchRecommendPlayListUseCase) )
        
    }
}
