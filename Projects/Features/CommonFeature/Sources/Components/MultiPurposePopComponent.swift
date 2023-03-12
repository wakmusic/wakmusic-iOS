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
    var editPlayListNameUseCase : any EditPlayListNameUseCase {get}
}

public final class MultiPurposePopComponent: Component<MultiPurposePopDependency> {
    public func makeView(type:PurposeType,key:String = "",completion: ((String) -> Void)? = nil ) -> MultiPurposePopupViewController  {
        return MultiPurposePopupViewController.viewController(viewModel: .init(
            type: type,
            key: key,
            createPlayListUseCase: dependency.createPlayListUseCase,
            loadPlayListUseCase: dependency.loadPlayListUseCase,
            setUserNameUseCase: dependency.setUserNameUseCase,
            editPlayListNameUseCase: dependency.editPlayListNameUseCase),
            completion: completion)
    }
}
