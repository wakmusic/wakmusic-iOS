//
//  SearchComponent.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import NeedleFoundation
import CommonFeature
import DomainModule

public protocol MyPlayListDependency: Dependency {
    var multiPurposePopComponent:  MultiPurposePopComponent {get}
    var playListDetailComponent:  PlayListDetailComponent {get}
    var containSongsComponent: ContainSongsComponent {get}
    var fetchPlayListUseCase: any FetchPlayListUseCase {get}
    var editPlayListOrderUseCase: any EditPlayListOrderUseCase {get}
    var deletePlayListUseCase: any DeletePlayListUseCase {get}
    var fetchPlayListDetailUseCase: any FetchPlayListDetailUseCase {get}
}

public final class MyPlayListComponent: Component<MyPlayListDependency> {
    public func makeView() -> MyPlayListViewController{
        return MyPlayListViewController.viewController(
            viewModel: .init(
                fetchPlayListUseCase: dependency.fetchPlayListUseCase,
                editPlayListOrderUseCase: dependency.editPlayListOrderUseCase,
                deletePlayListUseCase: dependency.deletePlayListUseCase,
                fetchPlayListDetailUseCase: dependency.fetchPlayListDetailUseCase
            ),
            multiPurposePopComponent: dependency.multiPurposePopComponent,
            playListDetailComponent: dependency.playListDetailComponent,
            containSongsComponent: dependency.containSongsComponent
        )
    }
}
