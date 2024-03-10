//
//  SearchComponent.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import CommonFeature
import UserDomainInterface
import Foundation
import NeedleFoundation

public protocol MyPlayListDependency: Dependency {
    var multiPurposePopComponent: MultiPurposePopComponent { get }
    var playListDetailComponent: PlayListDetailComponent { get }
    var fetchPlayListUseCase: any FetchPlayListUseCase { get }
    var editPlayListOrderUseCase: any EditPlayListOrderUseCase { get }
    var deletePlayListUseCase: any DeletePlayListUseCase { get }
}

public final class MyPlayListComponent: Component<MyPlayListDependency> {
    public func makeView() -> MyPlayListViewController {
        return MyPlayListViewController.viewController(
            viewModel: .init(
                fetchPlayListUseCase: dependency.fetchPlayListUseCase,
                editPlayListOrderUseCase: dependency.editPlayListOrderUseCase,
                deletePlayListUseCase: dependency.deletePlayListUseCase
            ),
            multiPurposePopComponent: dependency.multiPurposePopComponent,
            playListDetailComponent: dependency.playListDetailComponent
        )
    }
}
