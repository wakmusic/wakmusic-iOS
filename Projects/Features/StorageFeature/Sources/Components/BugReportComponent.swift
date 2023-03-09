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

public protocol BugReportDependency: Dependency {
    
    


}

public final class BugReportComponent: Component<BugReportDependency> {
    public func makeView() -> BugReportViewController {
        return BugReportViewController.viewController()
    }
}
