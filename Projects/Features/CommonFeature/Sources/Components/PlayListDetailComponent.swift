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

public protocol PlayListDetailDependency: Dependency {
    var fetchPlayListDetailUseCase: any FetchPlayListDetailUseCase {get}
  
    
}

public final class PlayListDetailComponent: Component<PlayListDetailDependency> {
    public func makeView(id:String) -> PlayListDetailViewController {
        return PlayListDetailViewController.viewController(viewModel: PlayListDetailViewModel(id:id,type:.wmRecommend,fetchPlayListDetailUseCase: dependency.fetchPlayListDetailUseCase))
        
    }
}
