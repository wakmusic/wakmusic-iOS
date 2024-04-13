//
//  SearchComponent.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import AuthDomainInterface
import CommonFeature
import Foundation
import NeedleFoundation
import UserDomainInterface

public protocol AfterLoginDependency: Dependency {
    var fetchUserInfoUseCase: any FetchUserInfoUseCase { get }
    var logoutUseCase: any LogoutUseCase { get }
    var requestComponent: RequestComponent { get }
    var profilePopComponent: ProfilePopComponent { get }
    var myPlayListComponent: MyPlayListComponent { get }
    var multiPurposePopComponent: MultiPurposePopComponent { get }
    var favoriteComponent: FavoriteComponent { get }
}

public final class AfterLoginComponent: Component<AfterLoginDependency> {
    public func makeView() -> AfterLoginViewController {
        return AfterLoginViewController.viewController(
            viewModel: .init(
                fetchUserInfoUseCase: dependency.fetchUserInfoUseCase,
                logoutUseCase: dependency.logoutUseCase
            ),
            requestComponent: dependency.requestComponent,
            profilePopComponent: dependency.profilePopComponent,
            myPlayListComponent: dependency.myPlayListComponent,
            multiPurposePopComponent: dependency.multiPurposePopComponent,
            favoriteComponent: dependency.favoriteComponent
        )
    }
}
