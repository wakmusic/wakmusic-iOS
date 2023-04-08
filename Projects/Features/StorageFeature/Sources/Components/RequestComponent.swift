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
import CommonFeature

public protocol RequestDependency: Dependency {
    var withdrawUserInfoUseCase: any WithdrawUserInfoUseCase {get}
    var qnaComponent: QnaComponent {get}
    var questionComponent: QuestionComponent {get}
    var containSongsComponent: ContainSongsComponent {get}
    var noticeComponent: NoticeComponent {get}
}

public final class RequestComponent: Component<RequestDependency> {
    public func makeView() -> RequestViewController {
        return RequestViewController.viewController(viewModel: .init(withDrawUserInfoUseCase: dependency.withdrawUserInfoUseCase),qnaComponent:dependency.qnaComponent,questionComponent: dependency.questionComponent,containSongsComponent: dependency.containSongsComponent, noticeComponent: dependency.noticeComponent)
    }
}
