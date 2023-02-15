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

public protocol SignInDependency: Dependency {
    var fetchTokenUseCase: any FetchTokenUseCase {get}
}

public final class SignInComponent: Component<SignInDependency> {
    public func makeView() -> LoginViewController {
        return LoginViewController.viewController(viewModel: .init(fetchTokenUseCase: dependency.fetchTokenUseCase))
    }
}
