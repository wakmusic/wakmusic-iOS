//
//  NewSongsContentComponent.swift
//  CommonFeature
//
//  Created by KTH on 2023/11/15.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import CommonFeature
import ChartDomainInterface
import Foundation
import NeedleFoundation
import SongsDomainInterface

public protocol NewSongsContentDependency: Dependency {
    var fetchNewSongsUseCase: any FetchNewSongsUseCase { get }
    var fetchChartUpdateTimeUseCase: any FetchChartUpdateTimeUseCase { get }
    var containSongsComponent: ContainSongsComponent { get }
}

public final class NewSongsContentComponent: Component<NewSongsContentDependency> {
    public func makeView(type: NewSongGroupType) -> NewSongsContentViewController {
        return NewSongsContentViewController.viewController(
            viewModel: .init(
                type: type,
                fetchNewSongsUseCase: dependency.fetchNewSongsUseCase,
                fetchChartUpdateTimeUseCase: dependency.fetchChartUpdateTimeUseCase
            ),
            containSongsComponent: dependency.containSongsComponent
        )
    }
}
