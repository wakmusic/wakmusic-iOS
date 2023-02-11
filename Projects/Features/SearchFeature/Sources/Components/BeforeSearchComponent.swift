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

public protocol BeforeSearchDependency: Dependency {
    var recommendPlayListDetailComponent : RecommendPlayListDetailComponent { get  }
    var fetchRecommendPlayListUseCase: any FetchRecommendPlayListUseCase {get}
  
    
}

public final class BeforeSearchComponent: Component<BeforeSearchDependency> {
    public func makeView() -> BeforeSearchContentViewController {
        return BeforeSearchContentViewController.viewController(recommendPlayListDetailComponent: dependency.recommendPlayListDetailComponent, viewModel: .init(fetchRecommendPlayListUseCase: dependency.fetchRecommendPlayListUseCase) )
        
    }
}
