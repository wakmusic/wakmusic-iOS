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

public protocol MultiPurposePopDependency: Dependency {
  
    
    var createPlayListUseCase : any CreatePlayListUseCase {get}
    var loadPlayListUseCase : any LoadPlayListUseCase {get}
    var setUserNameUseCase: any SetUserNameUseCase {get}
}

public final class MultiPurposePopComponent: Component<MultiPurposePopDependency> {
    public func makeView(type:PurposeType) -> MultiPurposePopupViewController  {
        return MultiPurposePopupViewController.viewController(viewModel: .init(type: type,
                                                            createPlayListUseCase: dependency.createPlayListUseCase,
                                                            loadPlayListUseCase: dependency.loadPlayListUseCase,
                                                            setUserNameUseCase: dependency.setUserNameUseCase))
    }
}
