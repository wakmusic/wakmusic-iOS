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

public protocol SuggestFunctionDependency: Dependency {
    var suggestFunctionUseCase: any SuggestFunctionUseCase { get }
}

public final class SuggestFunctionComponent: Component<SuggestFunctionDependency> {
    public func makeView() -> SuggestFunctionViewController {
        return SuggestFunctionViewController
            .viewController(viewModel: .init(suggestFunctionUseCase: dependency.suggestFunctionUseCase))
    }
}
