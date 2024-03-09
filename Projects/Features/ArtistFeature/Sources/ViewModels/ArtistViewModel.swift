//
//  ArtistViewModel.swift
//  ArtistFeatureTests
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import ArtistDomainInterface
import BaseFeature
import DomainModule
import Foundation
import RxCocoa
import RxSwift
import Utility

public final class ArtistViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    var fetchArtistListUseCase: FetchArtistListUseCase

    public init(
        fetchArtistListUseCase: any FetchArtistListUseCase
    ) {
        self.fetchArtistListUseCase = fetchArtistListUseCase
    }

    public struct Input {}

    public struct Output {
        let dataSource: BehaviorRelay<[ArtistListEntity]>
    }

    public func transform(from input: Input) -> Output {
        let dataSource: BehaviorRelay<[ArtistListEntity]> = BehaviorRelay(value: [])

        fetchArtistListUseCase.execute()
            .catchAndReturn([])
            .asObservable()
            .map { model -> [ArtistListEntity] in
                guard !model.isEmpty else {
                    DEBUG_LOG("데이터가 없습니다.")
                    return model
                }
                var newModel = model

                if model.count == 1 {
                    let hiddenItem: ArtistListEntity = ArtistListEntity(
                        artistId: "",
                        name: "",
                        short: "",
                        group: "",
                        title: "",
                        description: "",
                        color: [],
                        youtube: "",
                        twitch: "",
                        instagram: "",
                        imageRoundVersion: 0,
                        imageSquareVersion: 0,
                        graduated: false,
                        isHiddenItem: true
                    )
                    newModel.append(hiddenItem)
                    return newModel

                } else {
                    newModel.swapAt(0, 1)
                }
                return newModel
            }
            .bind(to: dataSource)
            .disposed(by: disposeBag)

        return Output(dataSource: dataSource)
    }
}
