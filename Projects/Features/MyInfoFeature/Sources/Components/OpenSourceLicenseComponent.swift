//
//  OpenSourceLicenseComponent.swift
//  CommonFeature
//
//  Created by KTH on 2023/05/17.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import NeedleFoundation

public protocol OpenSourceLicenseDependency: Dependency {}

public final class OpenSourceLicenseComponent: Component<OpenSourceLicenseDependency> {
    public func makeView() -> OpenSourceLicenseViewController {
        return OpenSourceLicenseViewController.viewController(
            viewModel: OpenSourceLicenseViewModel()
        )
    }
}
