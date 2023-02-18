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

public protocol ProfilePopDependency: Dependency {
    var setProfileUseCase: any SetProfileUseCase {get}
    var fetchUserInfoUseCase: any FetchUserInfoUseCase {get}
}

public final class ProfilePopComponent: Component<ProfilePopDependency> {
    public func makeView() -> ProfilePopViewController  {
        return ProfilePopViewController.viewController(
            viewModel: .init(setProfileUseCase: dependency.setProfileUseCase,
                             fetchUserInfoUseCase: dependency.fetchUserInfoUseCase)
        )
    }
}
