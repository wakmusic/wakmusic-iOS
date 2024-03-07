//
//  HomeComponent.swift
//  HomeFeatureTests
//
//  Created by KTH on 2023/02/20.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import CommonFeature
import DomainModule
import Foundation
import NeedleFoundation
import UIKit

public protocol HomeDependency: Dependency {
    var fetchChartRankingUseCase: any FetchChartRankingUseCase { get }
    var fetchNewSongsUseCase: any FetchNewSongsUseCase { get }
    var fetchRecommendPlayListUseCase: any FetchRecommendPlayListUseCase { get }
    var playListDetailComponent: PlayListDetailComponent { get }
    var newSongsComponent: NewSongsComponent { get }
}

public final class HomeComponent: Component<HomeDependency> {
    public func makeView() -> HomeViewController {
        return HomeViewController.viewController(
            viewModel: .init(
                fetchChartRankingUseCase: dependency.fetchChartRankingUseCase,
                fetchNewSongsUseCase: dependency.fetchNewSongsUseCase,
                fetchRecommendPlayListUseCase: dependency.fetchRecommendPlayListUseCase
            ),
            playListDetailComponent: dependency.playListDetailComponent,
            newSongsComponent: dependency.newSongsComponent
        )
    }
}
