//
//  PermissionComponent.swift
//  RootFeature
//
//  Created by KTH on 2023/04/05.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import NeedleFoundation

public protocol PermissionDependency: Dependency {
}

public final class PermissionComponent: Component<PermissionDependency> {
    public func makeView() -> PermissionViewController {
        return PermissionViewController.viewController()
    }
}
