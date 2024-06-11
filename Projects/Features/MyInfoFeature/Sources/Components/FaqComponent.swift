//
//  SearchComponent.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import FaqDomainInterface
import Foundation
import NeedleFoundation

public protocol FaqDependency: Dependency {
    var faqContentComponent: FaqContentComponent { get }
    var fetchFaqCategoriesUseCase: any FetchFaqCategoriesUseCase { get }
    var fetchFaqUseCase: any FetchFaqUseCase { get }
}

public final class FaqComponent: Component<FaqDependency> {
    public func makeView() -> FaqViewController {
        return FaqViewController.viewController(
            viewModel: .init(
                fetchFaqCategoriesUseCase: dependency.fetchFaqCategoriesUseCase,
                fetchQnaUseCase: dependency.fetchFaqUseCase
            ),
            faqContentComponent: dependency.faqContentComponent
        )
    }
}
