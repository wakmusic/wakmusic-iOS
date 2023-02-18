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

public protocol AfterLoginDependency: Dependency {
    var fetchUserInfoUseCase: any FetchUserInfoUseCase {get}
    var setProfileUseCase: any SetProfileUseCase {get}
    var requestComponent: RequestComponent {get}
}

public final class AfterLoginComponent: Component<AfterLoginDependency> {
    public func makeView() -> AfterLoginViewController {
        return AfterLoginViewController.viewController(
            viewModel: .init(
                fetchUserInfoUseCase: dependency.fetchUserInfoUseCase,
                setProfileUseCase: dependency.setProfileUseCase
            ),
            requestComponent: dependency.requestComponent
        )
    }
}
