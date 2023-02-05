//
//  PlayerViewModel.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/01/13.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Utility
import BaseFeature

final class PlayerViewModel: ViewModelType {
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let closeButtonDidTapEvent: Observable<Void>
        let playButtonDidTapEvent: Observable<Void>
        let prevButtonDidTapEvent: Observable<Void>
        let nextButtonDidTapEvent: Observable<Void>
        let repeatButtonDidTapEvent: Observable<Void>
        let shuffleButtonDidTapEvent: Observable<Void>
        let likeButtonDidTapEvent: Observable<Void>
        let addPlaylistButtonDidTapEvent: Observable<Void>
        let playlistButtonDidTapEvent: Observable<Void>
        let miniExtendButtonDidTapEvent: Observable<Void>
        let miniPlayButtonDidTapEvent: Observable<Void>
        let miniCloseButtonDidTapEvent: Observable<Void>
    }
    struct Output {
        var titleText = BehaviorRelay<String>(value: "")
        var artistText = BehaviorRelay<String>(value: "")
        var thumbnailImageURL = BehaviorRelay<String>(value: "")
        var lyricsArray = BehaviorRelay<[String]>(value: ["", "", "", "", ""])
        var playTimeValue = BehaviorRelay<Float>(value: 0.0)
        var currentTimeText = BehaviorRelay<String>(value: "0:00")
        var totalTimeText = BehaviorRelay<String>(value: "0:00")
        var likeCountText = BehaviorRelay<String>(value: "")
        var viewsCountText = BehaviorRelay<String>(value: "")
    }
    
    private let useCase: PlayerUseCase
    private let disposeBag = DisposeBag()

    init() {
        self.useCase = DefaultPlayerUseCase()
        print("✅ PlayerViewModel 생성")
    }
    
    func transform(from input: Input) -> Output {
        let output = Output()
        
        Observable.of(input.playButtonDidTapEvent, input.miniPlayButtonDidTapEvent).merge()
            .subscribe { [weak self] _ in
                print("플레이버튼 눌림")
            }
            .disposed(by: disposeBag)
        
        input.miniExtendButtonDidTapEvent.subscribe { _ in
            print("미니플레이어 확장버튼 눌림")
        }.disposed(by: disposeBag)
        
        return output
    }
}
