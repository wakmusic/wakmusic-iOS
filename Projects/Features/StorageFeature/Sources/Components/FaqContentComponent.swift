//
//  SearchComponent.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DomainModule
import Foundation
import NeedleFoundation

public final class FaqContentComponent: Component<EmptyDependency> {
    public func makeView(dataSource: [FaqEntity]) -> FaqContentViewController {
        return FaqContentViewController.viewController(viewModel: .init(dataSource: dataSource))
    }
}
