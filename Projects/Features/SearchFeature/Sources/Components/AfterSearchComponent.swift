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

public protocol AfterSearchDependency: Dependency {
    var afterSearchContentComponent: AfterSearchContentComponent {get}
    
}

public final class AfterSearchComponent: Component<AfterSearchDependency> {
    public func makeView() -> AfterSearchViewController {
        return AfterSearchViewController.viewController(afterSearchContentComponent: dependency.afterSearchContentComponent, viewModel: .init())
        
    }
}
