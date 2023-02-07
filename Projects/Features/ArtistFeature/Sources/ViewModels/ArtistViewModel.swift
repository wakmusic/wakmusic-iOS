//
//  ArtistViewModel.swift
//  ArtistFeatureTests
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import BaseFeature
import DomainModule
import Utility

public final class ArtistViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    var fetchArtistListUseCase: FetchArtistListUseCase

    public init(
        fetchArtistListUseCase: any FetchArtistListUseCase
    ){
        self.fetchArtistListUseCase = fetchArtistListUseCase
    }

    public struct Input {
    }

    public struct Output {
        var dataSource: BehaviorRelay<[ArtistListEntity]>
    }
    
    public func transform(from input: Input) -> Output {
        
        let dataSource: BehaviorRelay<[ArtistListEntity]> = BehaviorRelay(value: [])

        fetchArtistListUseCase.execute()
            .debug("fetchArtistListUseCase")
            .catchAndReturn([])
            .asObservable()
            .bind(to: dataSource)
            .disposed(by: disposeBag)

        return Output(dataSource: dataSource)
    }
}
