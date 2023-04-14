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

public protocol WakMusicFeedbackDependency: Dependency {
    var inquiryWeeklyChartUseCase: any InquiryWeeklyChartUseCase { get }
}

public final class WakMusicFeedbackComponent: Component<WakMusicFeedbackDependency> {
    public func makeView() -> WakMusicFeedbackViewController {
        return WakMusicFeedbackViewController.viewController(viewModel: .init(inquiryWeeklyChartUseCase: dependency.inquiryWeeklyChartUseCase))
    }
}
