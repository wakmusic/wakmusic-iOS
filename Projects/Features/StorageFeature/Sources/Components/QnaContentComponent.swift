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

public protocol QnaContentDependency: Dependency {
    
    var fetchQnaUseCase : any FetchQnaUseCase {get}
}

public final class QnaContentComponent: Component<QnaContentDependency> {
    public func makeView() -> QnaContentViewController {
        return QnaContentViewController.viewController([])
    }
}
