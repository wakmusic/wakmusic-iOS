//
//  ArtistMusicContentViewModel.swift
//  ArtistFeature
//
//  Created by KTH on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import BaseFeature
import DomainModule
import DataMappingModule
import Utility

public final class ArtistMusicContentViewModel: ViewModelType {

    var fetchArtistSongListUseCase: FetchArtistSongListUseCase
    var type: ArtistSongSortType
    var model: ArtistListEntity?
    var disposeBag = DisposeBag()

    public init(
        type: ArtistSongSortType,
        model: ArtistListEntity?,
        fetchArtistSongListUseCase: any FetchArtistSongListUseCase
    ){
        self.type = type
        self.model = model
        self.fetchArtistSongListUseCase = fetchArtistSongListUseCase
    }
    
    public struct Input {
    }

    public struct Output {
        let dataSource: BehaviorRelay<[ArtistSongListEntity]>
    }
    
    public func transform(from input: Input) -> Output {
        let ID: String = model?.ID ?? ""
        let dataSource: BehaviorRelay<[ArtistSongListEntity]> = BehaviorRelay(value: [])
        
        fetchArtistSongListUseCase
            .execute(id: ID, sort: type, page: 1)
            .catchAndReturn([])
            .asObservable()
            .bind(to: dataSource)
            .disposed(by: disposeBag)
        
        return Output(dataSource: dataSource)
    }
}
