//
//  HomeComponent.swift
//  HomeFeatureTests
//
//  Created by KTH on 2023/02/20.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import UIKit
import NeedleFoundation
import DomainModule

public protocol HomeDependency: Dependency {
    var fetchNewSongUseCase: any FetchNewSongUseCase { get }
}

public final class HomeComponent: Component<HomeDependency> {
    public func makeView() -> HomeViewController {
        return HomeViewController.viewController(viewModel: .init(fetchNewSongUseCase: dependency.fetchNewSongUseCase))
    }
}
