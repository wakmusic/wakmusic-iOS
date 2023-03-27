//
//  BeforeSearchComponent.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import NeedleFoundation
import DomainModule
import DataMappingModule

public protocol PlayListDetailDependency: Dependency {
    var fetchPlayListDetailUseCase: any FetchPlayListDetailUseCase {get}
    
    var editPlayListUseCase : any EditPlayListUseCase {get}
    var removeSongsUseCase : any RemoveSongsUseCase {get}
    
    var multiPurposePopComponent: MultiPurposePopComponent {get}
    var containSongsComponent : ContainSongsComponent {get}
    
    
}

public final class PlayListDetailComponent: Component<PlayListDetailDependency> {
    public func makeView(id:String,type:PlayListType) -> PlayListDetailViewController {
        return PlayListDetailViewController.viewController(viewModel: PlayListDetailViewModel(
            id:id,
            type:type,
            fetchPlayListDetailUseCase: dependency.fetchPlayListDetailUseCase,
            editPlayListUseCase: dependency.editPlayListUseCase,
            removeSongsUseCase: dependency.removeSongsUseCase),
            multiPurposePopComponent: dependency.multiPurposePopComponent,
            containSongsComponent:dependency.containSongsComponent)
        
    }
}
