//
//  SearchComponent.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import AuthDomainInterface
import BaseFeature
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import PlaylistFeatureInterface
import UserDomainInterface

public protocol MyPlayListDependency: Dependency {
    var multiPurposePopUpFactory: any MultiPurposePopUpFactory { get }
    var playlistDetailFactory: any PlaylistDetailFactory { get }
    var fetchPlayListUseCase: any FetchPlayListUseCase { get }
    var editPlayListOrderUseCase: any EditPlayListOrderUseCase { get }
    var deletePlayListUseCase: any DeletePlayListUseCase { get }
    var logoutUseCase: any LogoutUseCase { get }
    var textPopUpFactory: any TextPopUpFactory { get }
}

public final class MyPlayListComponent: Component<MyPlayListDependency> {
    public func makeView() -> MyPlayListViewController {
        return MyPlayListViewController.viewController(
            viewModel: .init(
                fetchPlayListUseCase: dependency.fetchPlayListUseCase,
                editPlayListOrderUseCase: dependency.editPlayListOrderUseCase,
                deletePlayListUseCase: dependency.deletePlayListUseCase,
                logoutUseCase: dependency.logoutUseCase
            ),
            multiPurposePopUpFactory: dependency.multiPurposePopUpFactory,
            playlistDetailFactory: dependency.playlistDetailFactory,
            textPopUpFactory: dependency.textPopUpFactory
        )
    }
}
