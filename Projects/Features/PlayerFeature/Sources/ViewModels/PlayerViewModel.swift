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
import YoutubeKit
import DomainModule

final class PlayerViewModel: ViewModelType {
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let closeButtonDidTapEvent: Observable<Void>
        let playButtonDidTapEvent: Observable<Void>
        let prevButtonDidTapEvent: Observable<Void>
        let nextButtonDidTapEvent: Observable<Void>
        let sliderValueChangedEvent: Observable<Float>
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
        var playerState = BehaviorRelay<YTSwiftyPlayerState>(value: .unstarted)
        var titleText = BehaviorRelay<String>(value: "")
        var artistText = BehaviorRelay<String>(value: "")
        var thumbnailImageURL = BehaviorRelay<String>(value: "")
        var lyricsArray = BehaviorRelay<[String]>(value: ["", "", "", "", ""])
        var playTimeValue = BehaviorRelay<Float>(value: 0.0)
        var totalTimeValue = BehaviorRelay<Float>(value: 0.0)
        var playTimeText = BehaviorRelay<String>(value: "0:00")
        var totalTimeText = BehaviorRelay<String>(value: "0:00")
        var likeCountText = BehaviorRelay<String>(value: "")
        var viewsCountText = BehaviorRelay<String>(value: "")
        var didPlay = PublishRelay<Bool>()
        var didClose = PublishRelay<Bool>()
        var didPrev = PublishRelay<Bool>()
        var didNext = PublishRelay<Bool>()
    }
    
    var fetchLyricsUseCase: FetchLyricsUseCase!
    
    private let playState = PlayState.shared
    private let disposeBag = DisposeBag()

    init(fetchLyricsUseCase: FetchLyricsUseCase) {
        self.fetchLyricsUseCase = fetchLyricsUseCase
        print("✅ PlayerViewModel 생성")
        self.fetchLyricsUseCase.execute(id: "pl38om066m0").subscribe {
            DEBUG_LOG($0)
        }.disposed(by: disposeBag)

    }
    
    func transform(from input: Input) -> Output {
        let output = Output()
        
        Observable.of(input.playButtonDidTapEvent, input.miniPlayButtonDidTapEvent).merge()
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                let state = try? self.playState.state.value()
                state == .playing ? self.playState.pause() : self.playState.play()
            })
            .disposed(by: disposeBag)
        
        input.miniExtendButtonDidTapEvent.subscribe { _ in
            print("미니플레이어 확장버튼 눌림")
        }.disposed(by: disposeBag)
        
        input.miniCloseButtonDidTapEvent.subscribe { _ in
            print("미니플레이어 닫기버튼 눌림")
            output.didClose.accept(true)
        }.disposed(by: disposeBag)
        
        input.prevButtonDidTapEvent.subscribe { [weak self] _ in
            guard let self else { return }
            self.playState.backWard()
        }.disposed(by: disposeBag)
        
        input.nextButtonDidTapEvent.subscribe { [weak self] _ in
            guard let self else { return }
            self.playState.forWard()
        }.disposed(by: disposeBag)
        
        input.sliderValueChangedEvent.subscribe { [weak self] value in
            guard let self else { return }
            self.playState.player.seek(to: Int(value), allowSeekAhead: true)
        }.disposed(by: disposeBag)
        
        PlayState.shared.state.bind { state in
            output.playerState.accept(state)
        }.disposed(by: disposeBag)
        
        PlayState.shared.progress.bind { [weak self] progress in
            guard let self else { return }
            output.playTimeText.accept(self.timeString(from: progress.currentProgress))
            output.totalTimeText.accept(self.timeString(from: progress.endProgress))
            output.playTimeValue.accept(Float(progress.currentProgress))
            output.totalTimeValue.accept(Float(progress.endProgress))
        }.disposed(by: disposeBag)
        
        
        return output
    }
    
    func timeString(from second: Double) -> String {
        let second = Int(floor(second))
        let min = second / 60
        let sec = String(format: "%02d", second % 60)
        return "\(min):\(sec)"
    }
}
