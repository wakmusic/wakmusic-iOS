//
//  LyricDecoratingViewModel.swift
//  LyricHighlightingFeature
//
//  Created by KTH on 6/3/24.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import BaseFeature
import Foundation
import LogManager
import RxRelay
import RxSwift
import SongsDomainInterface
import UIKit
import Utility

final class LyricDecoratingViewModel: ViewModelType {
    private var model: LyricHighlightingRequiredModel = .init(songID: "", title: "", artist: "", highlightingItems: [])
    private let disposeBag = DisposeBag()

    deinit {
        LogManager.printDebug("❌:: \(Self.self) deinit")
    }

    public init(
        model: LyricHighlightingRequiredModel
    ) {
        self.model = model
    }

    public struct Input {
        let fetchBackgroundImage: PublishSubject<Void> = PublishSubject()
        let didTapBackground: PublishSubject<IndexPath> = PublishSubject()
    }

    public struct Output {
        let dataSource: BehaviorRelay<[LyricDecoratingModel]> = BehaviorRelay(value: [])
        let highlightingItems: BehaviorRelay<String> = BehaviorRelay(value: "")
        let updateSongTitle: BehaviorRelay<String> = BehaviorRelay(value: "")
        let updateArtist: BehaviorRelay<String> = BehaviorRelay(value: "")
    }

    public func transform(from input: Input) -> Output {
        let output = Output()

        #warning("TO-DO: API 나오면 UseCase로 대체")
        input.fetchBackgroundImage
            .map { _ -> [LyricDecoratingModel] in
                return Array(0 ... 9).map { i -> LyricDecoratingModel in
                    LyricDecoratingModel(imageURL: "", imageColor: UIColor.random(), isSelected: i == 0 ? true : false)
                }
            }
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)

        output.highlightingItems
            .accept(model.highlightingItems.joined(separator: "\n"))
        output.updateSongTitle.accept(model.title)
        output.updateArtist.accept(model.artist)

        input.didTapBackground
            .map { $0.item }
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .map { index, entities in
                var newEntities = entities
                if let i = entities.firstIndex(where: { $0.isSelected }) {
                    newEntities[i].isSelected = false
                }
                newEntities[index].isSelected = true
                return newEntities
            }
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)

        return output
    }
}
