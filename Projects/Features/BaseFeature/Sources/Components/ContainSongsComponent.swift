//
//  BeforeSearchComponent.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import AuthDomainInterface
import Foundation
import NeedleFoundation
import PlayListDomainInterface
import UserDomainInterface
import BaseFeatureInterface

public protocol ContainSongsDependency: Dependency {
    
    var multiPurposePopUpFactory: any MultiPurposePopUpFactory { get }
    var fetchPlayListUseCase: any FetchPlayListUseCase { get }
    var addSongIntoPlayListUseCase: any AddSongIntoPlayListUseCase { get }
    var logoutUseCase: any LogoutUseCase { get }
}

public final class ContainSongsComponent: Component<ContainSongsDependency> {
    public func makeView(songs: [String]) -> ContainSongsViewController {
        return ContainSongsViewController.viewController(
            multiPurposePopUpFactory: dependency.multiPurposePopUpFactory,
            viewModel: .init(
                songs: songs,
                fetchPlayListUseCase: dependency.fetchPlayListUseCase,
                addSongIntoPlayListUseCase: dependency.addSongIntoPlayListUseCase,
                logoutUseCase: dependency.logoutUseCase
            )
        )
    }
}
