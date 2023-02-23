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
    var  multiPurposePopComponent :  MultiPurposePopComponent {get}
    var  fetchPlayListUseCase : any FetchPlayListUseCase {get}
   
}

public final class MyPlayListComponent: Component<MyPlayListDependency> {
    public func makeView() -> MyPlayListViewController{
        
        return MyPlayListViewController.viewController(viewModel: .init(fetchPlayListUseCase: dependency.fetchPlayListUseCase), multiPurposePopComponent: dependency.multiPurposePopComponent)
    }
}
