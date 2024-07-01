//
//  ArtistDetailComponent.swift
//  ArtistFeature
//
//  Created by KTH on 2023/02/09.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import ArtistDomainInterface
import Foundation
import NeedleFoundation

public protocol ArtistDetailDependency: Dependency {
    var artistMusicComponent: ArtistMusicComponent { get }
    var fetchArtistSubscriptionStatusUseCase: any FetchArtistSubscriptionStatusUseCase { get }
    var subscriptionArtistUseCase: any SubscriptionArtistUseCase { get }
}

public final class ArtistDetailComponent: Component<ArtistDetailDependency> {
    public func makeView(model: ArtistListEntity) -> ArtistDetailViewController {
        return ArtistDetailViewController.viewController(
            model: model,
            artistMusicComponent: dependency.artistMusicComponent
        )
    }
}
