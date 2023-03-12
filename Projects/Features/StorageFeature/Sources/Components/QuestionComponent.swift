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

public protocol QuestionDependency: Dependency {
    
    var suggestFunctionComponent: SuggestFunctionComponent {get}
    var wakMusicFeedbackComponent: WakMusicFeedbackComponent {get}
    var askSongComponent : AskSongComponent {get}
    var bugReportComponent : BugReportComponent {get}

}

public final class QuestionComponent: Component<QuestionDependency> {
    public func makeView() -> QuestionViewController {
        return QuestionViewController.viewController(viewModel: .init(),suggestFunctionComponent: dependency.suggestFunctionComponent,wakMusicFeedbackComponent: dependency.wakMusicFeedbackComponent,askSongComponent: dependency.askSongComponent,bugReportComponent: dependency.bugReportComponent)
    }
}
