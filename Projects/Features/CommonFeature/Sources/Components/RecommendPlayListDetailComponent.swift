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

public protocol RecommendPlayListDetailDependency: Dependency {
    var fetchRecommendPlayListDetailUseCase: any FetchRecommendPlayListDetailUseCase {get}
  
    
}

public final class RecommendPlayListDetailComponent: Component<RecommendPlayListDetailDependency> {
    public func makeView() -> PlayListDetailViewController {
        return PlayListDetailViewController.viewController(viewModel: PlayListDetailViewModel(type:.wmRecommend,fetchRecommendPlayListDetailUseCase: dependency.fetchRecommendPlayListDetailUseCase))
        
    }
}
