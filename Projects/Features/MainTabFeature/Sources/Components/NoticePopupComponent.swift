//
//  NoticePopupComponent.swift
//  CommonFeature
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import NeedleFoundation
import NoticeDomainInterface

public protocol NoticePopupDependency: Dependency {}

public final class NoticePopupComponent: Component<NoticePopupDependency> {
    public func makeView(model: [FetchNoticeEntity]) -> NoticePopupViewController {
        return NoticePopupViewController.viewController(
            viewModel: .init(noticeEntities: model)
        )
    }
}
