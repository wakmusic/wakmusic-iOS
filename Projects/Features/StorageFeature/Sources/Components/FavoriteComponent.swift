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
import DomainModule
import CommonFeature

public protocol FavoriteDependency: Dependency {
    var containSongsComponent: ContainSongsComponent {get}
    var fetchFavoriteSongsUseCase: any FetchFavoriteSongsUseCase {get}
    var editFavoriteSongsOrderUseCase: any EditFavoriteSongsOrderUseCase {get}
    var deleteFavoriteListUseCase: any DeleteFavoriteListUseCase {get}
}

public final class FavoriteComponent: Component<FavoriteDependency> {
    public func makeView() -> FavoriteViewController {
        return FavoriteViewController.viewController(
            viewModel: .init(
                fetchFavoriteSongsUseCase: dependency.fetchFavoriteSongsUseCase,
                editFavoriteSongsOrderUseCase: dependency.editFavoriteSongsOrderUseCase,
                deleteFavoriteListUseCase: dependency.deleteFavoriteListUseCase
            ),
            containSongsComponent: dependency.containSongsComponent
        )
    }
}
