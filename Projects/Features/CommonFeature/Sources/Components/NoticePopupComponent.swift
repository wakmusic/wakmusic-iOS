//
//  NoticePopupComponent.swift
//  CommonFeature
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import NeedleFoundation
import DomainModule

public protocol NoticePopupDependency: Dependency {
    var fetchNoticeUseCase: any FetchNoticeUseCase {get}
}

public final class NoticePopupComponent: Component<NoticePopupDependency> {
    public func makeView() -> NoticePopupViewController  {
        return NoticePopupViewController.viewController(
            viewModel: .init(
                fetchNoticeUseCase: dependency.fetchNoticeUseCase
            )
        )
    }
}
