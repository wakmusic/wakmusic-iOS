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

public protocol QnaDependency: Dependency {
    

    var qnaContentComponent : QnaContentComponent {get}
    var fetchQnaCategoriesUseCase : any FetchQnaCategoriesUseCase {get}
    

}

public final class QnaComponent: Component<QnaDependency> {
    public func makeView() -> QnaViewController {
        return QnaViewController.viewController(viewModel: .init(fetchQnaCategoriesUseCase: dependency.fetchQnaCategoriesUseCase), qnaContentComponent: dependency.qnaContentComponent)
    }
}
