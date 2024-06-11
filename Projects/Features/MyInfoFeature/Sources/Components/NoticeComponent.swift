//
//  NoticeComponent.swift
//  StorageFeature
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import NeedleFoundation
import NoticeDomainInterface

public protocol NoticeDependency: Dependency {
    var fetchNoticeUseCase: any FetchNoticeUseCase { get }
    var noticeDetailComponent: NoticeDetailComponent { get }
}

public final class NoticeComponent: Component<NoticeDependency> {
    public func makeView() -> NoticeViewController {
        return NoticeViewController.viewController(
            viewModel: .init(
                fetchNoticeUseCase: dependency.fetchNoticeUseCase
            ),
            noticeDetailComponent: dependency.noticeDetailComponent
        )
    }
}
