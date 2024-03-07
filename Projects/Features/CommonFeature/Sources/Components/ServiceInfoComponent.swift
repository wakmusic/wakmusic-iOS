//
//  ServiceInfoComponent.swift
//  CommonFeature
//
//  Created by KTH on 2023/05/17.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import NeedleFoundation

public protocol ServiceInfoDependency: Dependency {
    var openSourceLicenseComponent: OpenSourceLicenseComponent { get }
}

public final class ServiceInfoComponent: Component<ServiceInfoDependency> {
    public func makeView() -> ServiceInfoViewController {
        return ServiceInfoViewController.viewController(
            viewModel: ServiceInfoViewModel(),
            openSourceLicenseComponent: dependency.openSourceLicenseComponent
        )
    }
}
