//
//  BeforeSearchComponent.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import BaseFeature
import Foundation
import NeedleFoundation

public protocol AfterSearchComponentDependency: Dependency {}

public final class AfterSearchContentComponent: Component<AfterSearchComponentDependency> {
    public func makeView(
        type: TabPosition,
        dataSource: [SearchSectionModel]
    ) -> AfterSearchContentViewController {
        return AfterSearchContentViewController.viewController(
            viewModel: .init(
                type: type,
                dataSource: dataSource
            )
        )
    }
}
