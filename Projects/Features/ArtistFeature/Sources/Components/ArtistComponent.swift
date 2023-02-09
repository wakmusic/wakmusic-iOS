//
//  ArtistComponent.swift
//  ArtistFeatureTests
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import UIKit
import NeedleFoundation
import DomainModule

//MARK :Artist
public protocol ArtistDependency: Dependency {
    var fetchArtistListUseCase: any FetchArtistListUseCase { get }
    var artistDetailComponent: ArtistDetailComponent { get }
}

public final class ArtistComponent: Component<ArtistDependency> {
    public func makeView() -> ArtistViewController {
        return ArtistViewController.viewController(
            viewModel: ArtistViewModel(fetchArtistListUseCase: dependency.fetchArtistListUseCase.self),
            artistDetailComponent: dependency.artistDetailComponent.self
        )
    }
}

//MARK :Artist Detail
public protocol ArtistDetailDependency: Dependency {
}

public final class ArtistDetailComponent: Component<ArtistDetailDependency> {
    public func makeView(model: ArtistListEntity) -> ArtistDetailViewController {
        return ArtistDetailViewController.viewController(model: model)
    }
}
