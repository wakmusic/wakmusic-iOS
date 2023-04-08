//
//  NoticeDetailComponent.swift
//  StorageFeature
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import NeedleFoundation
import DomainModule

public protocol NoticeDetailDependency: Dependency {
}

public final class NoticeDetailComponent: Component<NoticeDetailDependency> {
    public func makeView(model: FetchNoticeEntity) -> NoticeDetailViewController  {
        return NoticeDetailViewController.viewController(
            viewModel: .init(
                model: model
            )
        )
    }
}
