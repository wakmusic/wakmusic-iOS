//
//  SearchComponent.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import NeedleFoundation
import SignInFeature

public protocol StorageDependency: Dependency {
    var signInComponent: SignInComponent { get }
    var afterLoginComponent: AfterLoginComponent { get }
}

public final class StorageComponent: Component<StorageDependency> {
    public func makeView() -> StorageViewController {
        return StorageViewController.viewController(
            signInComponent: dependency.signInComponent,
            afterLoginComponent: dependency.afterLoginComponent
        )
    }
}
