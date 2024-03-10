//
//  SearchComponent.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import AuthDomainInterface
import Foundation
import NeedleFoundation
import UserDomainInterface

public protocol SignInDependency: Dependency {
    var fetchTokenUseCase: any FetchTokenUseCase { get }
    var fetchNaverUserInfoUseCase: any FetchNaverUserInfoUseCase { get }
    var fetchUserInfoUseCase: any FetchUserInfoUseCase { get }
}

public final class SignInComponent: Component<SignInDependency> {
    public func makeView() -> LoginViewController {
        return LoginViewController.viewController(
            viewModel: .init(
                fetchTokenUseCase: dependency.fetchTokenUseCase,
                fetchNaverUserInfoUseCase: dependency.fetchNaverUserInfoUseCase,
                fetchUserInfoUseCase: dependency.fetchUserInfoUseCase
            )
        )
    }
}
