//
//  BeforeSearchComponent.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import AuthDomainInterface
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import PlayListDomainInterface
import UIKit
import UserDomainInterface

public protocol MultiPurposePopUpDependency: Dependency {
    var createPlayListUseCase: any CreatePlayListUseCase { get }
    var loadPlayListUseCase: any LoadPlayListUseCase { get }
    var setUserNameUseCase: any SetUserNameUseCase { get }
    var editPlayListNameUseCase: any EditPlayListNameUseCase { get }
    var logoutUseCase: any LogoutUseCase { get }
}

public final class MultiPurposePopUpComponent: Component<MultiPurposePopUpDependency>, MultiPurposePopUpFactory {
    public func makeView(
        type: PurposeType,
        key: String,
        completion: ((String) -> Void)?
    ) -> UIViewController {
        return MultiPurposePopupViewController.viewController(
            viewModel: .init(
                type: type,
                key: key,
                createPlayListUseCase: dependency.createPlayListUseCase,
                loadPlayListUseCase: dependency.loadPlayListUseCase,
                setUserNameUseCase: dependency.setUserNameUseCase,
                editPlayListNameUseCase: dependency.editPlayListNameUseCase,
                logoutUseCase: dependency.logoutUseCase
            ),
            completion: completion
        )
    }
}
