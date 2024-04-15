//
//  SearchComponent.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import AuthDomainInterface
import BaseFeature
import Foundation
import NeedleFoundation
import UserDomainInterface

public protocol RequestDependency: Dependency {
    var withdrawUserInfoUseCase: any WithdrawUserInfoUseCase { get }
    var logoutUseCase: any LogoutUseCase { get }
    var faqComponent: FaqComponent { get }
    var questionComponent: QuestionComponent { get }
    var containSongsComponent: ContainSongsComponent { get }
    var noticeComponent: NoticeComponent { get }
    var serviceInfoComponent: ServiceInfoComponent { get }
}

public final class RequestComponent: Component<RequestDependency> {
    public func makeView() -> RequestViewController {
        return RequestViewController.viewController(
            viewModel: .init(
                withDrawUserInfoUseCase: dependency.withdrawUserInfoUseCase,
                logoutUseCase: dependency.logoutUseCase
            ),
            faqComponent: dependency.faqComponent,
            questionComponent: dependency.questionComponent,
            containSongsComponent: dependency.containSongsComponent,
            noticeComponent: dependency.noticeComponent,
            serviceInfoComponent: dependency.serviceInfoComponent
        )
    }
}
