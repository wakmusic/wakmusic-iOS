//
//  SearchComponent.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import NeedleFoundation

public protocol SearchDependency: Dependency {
    var beforeSearchComponent:  BeforeSearchComponent { get }
    var afterSearchComponent: AfterSearchComponent { get }
}

public final class SearchComponent: Component<SearchDependency> {
    public func makeView() -> SearchViewController {
        return SearchViewController.viewController(
            viewModel: .init(),
            beforeSearchComponent: self.dependency.beforeSearchComponent,
            afterSearchComponent: self.dependency.afterSearchComponent
        )
    }
}
