//
//  ArtistMusicContentComponent.swift
//  ArtistFeature
//
//  Created by KTH on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import ArtistDomainInterface
import CommonFeature
import Foundation
import NeedleFoundation

public protocol ArtistMusicContentDependency: Dependency {
    var fetchArtistSongListUseCase: any FetchArtistSongListUseCase { get }
    var containSongsComponent: ContainSongsComponent { get }
}

public final class ArtistMusicContentComponent: Component<ArtistMusicContentDependency> {
    public func makeView(
        type: ArtistSongSortType,
        model: ArtistListEntity?
    ) -> ArtistMusicContentViewController {
        return ArtistMusicContentViewController.viewController(
            viewModel: .init(
                type: type,
                model: model,
                fetchArtistSongListUseCase: dependency.fetchArtistSongListUseCase
            ),
            containSongsComponent: dependency.containSongsComponent
        )
    }
}
