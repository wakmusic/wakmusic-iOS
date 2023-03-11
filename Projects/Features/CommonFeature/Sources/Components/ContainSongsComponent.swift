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

public protocol ContainSongsDependency: Dependency {
    var  multiPurposePopComponent :  MultiPurposePopComponent {get}
    
    
}

public final class ContainSongsComponent: Component<ContainSongsDependency> {
    public func makeView() -> ContainSongsViewController  {
        return ContainSongsViewController.viewController(multiPurposePopComponent: dependency.multiPurposePopComponent ,viewModel: .init())
    }
}
