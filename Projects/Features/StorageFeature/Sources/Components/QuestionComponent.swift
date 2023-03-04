//
//  SearchComponent.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import NeedleFoundation
import DomainModule

public protocol QuestionDependency: Dependency {
    


}

public final class QuestionComponent: Component<QuestionDependency> {
    public func makeView() -> QuestionViewController {
        return QuestionViewController.viewController(viewModel: .init())
    }
}
