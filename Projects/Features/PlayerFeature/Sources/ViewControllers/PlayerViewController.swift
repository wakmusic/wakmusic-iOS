//
//  PlayerViewController.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/01/09.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem
import SnapKit
import Then
import RxCocoa
import RxSwift
import YoutubeKit

public class PlayerViewController: UIViewController {
    private let disposeBag = DisposeBag()
    var viewModel = PlayerViewModel()
    private var youtubePlayer: YTSwiftyPlayer!
    var playerView: PlayerView!
    var miniPlayerView: MiniPlayerView!
    
    var youtubePlayerView = UIView().then {
        $0.isHidden = false
    }
    
    public override func loadView() {
        super.loadView()
        playerView = PlayerView(frame: self.view.frame)
        miniPlayerView = MiniPlayerView(frame: self.view.frame)
        miniPlayerView.layer.opacity = 0
        self.view.addSubview(playerView)
        self.view.addSubview(miniPlayerView)
        self.view.addSubview(youtubePlayerView)
        self.youtubePlayerView.snp.makeConstraints {
            $0.centerX.centerY.equalTo(self.playerView.thumbnailImageView)
            $0.width.equalTo(320)
            $0.height.equalTo(180)
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        setupYoutubePlayer()
        bindViewModel()
        bindUI()
    }
    
    func setupYoutubePlayer() {
        self.youtubePlayer = YTSwiftyPlayer(
            frame: .init(x: 0, y: 0, width: 320, height: 180),
            playerVars: [
                .playsInline(true),
                .videoID("PVRkT5ZvXLU"),
                .loopVideo(true),
                .showRelatedVideo(false),
                .autoplay(true)
            ])
        
        youtubePlayer.delegate = self
        self.youtubePlayerView.addSubview(youtubePlayer)
        
        youtubePlayer.loadPlayerHTML(playerHtml)
    }
    
}

public extension PlayerViewController {
    func updateOpacity(value: Float) {
        playerView.layer.opacity = value
        miniPlayerView.layer.opacity = 1 - value
    }
}

private extension PlayerViewController {
    private func bindViewModel() {
        let input = PlayerViewModel.Input(
            viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map {_ in },
            closeButtonDidTapEvent: self.playerView.closeButton.rx.tap.asObservable(),
            playButtonDidTapEvent: self.playerView.playButton.rx.tap.asObservable(),
            prevButtonDidTapEvent: self.playerView.prevButton.rx.tap.asObservable(),
            nextButtonDidTapEvent: self.playerView.nextButton.rx.tap.asObservable(),
            repeatButtonDidTapEvent: self.playerView.repeatButton.rx.tap.asObservable(),
            shuffleButtonDidTapEvent: self.playerView.shuffleButton.rx.tap.asObservable(),
            likeButtonDidTapEvent: self.playerView.likeButton.rx.tap.asObservable(),
            addPlaylistButtonDidTapEvent: self.playerView.addPlayistButton.rx.tap.asObservable(),
            playlistButtonDidTapEvent: self.playerView.playistButton.rx.tap.asObservable(),
            miniExtendButtonDidTapEvent: self.miniPlayerView.extendButton.rx.tap.asObservable(),
            miniPlayButtonDidTapEvent: self.miniPlayerView.playButton.rx.tap.asObservable(),
            miniCloseButtonDidTapEvent: self.miniPlayerView.closeButton.rx.tap.asObservable()
        )
        let output = self.viewModel.transform(from: input)

        output.didPlay
            .asDriver(onErrorJustReturn: false)
            .filter { $0 }
            .drive(onNext: { [weak self] _ in
                print("didPlay")
                self?.youtubePlayer.loadVideo(videoID: "dfcztPNevwg")
            })
            .disposed(by: disposeBag)

        output.didClose
            .asDriver(onErrorJustReturn: false)
            .filter { $0 }
            .drive(onNext: { [weak self] _ in
                print("didClose")
            })
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {

    }
}

extension PlayerViewController: YTSwiftyPlayerDelegate {
    public func player(_ player: YTSwiftyPlayer, didChangeState state: YTSwiftyPlayerState) {
        
    }
    
    public func player(_ player: YTSwiftyPlayer, didChangeQuality quality: YTSwiftyVideoQuality) {
        
    }
    
    public func player(_ player: YTSwiftyPlayer, didReceiveError error: YTSwiftyPlayerError) {
        
    }
    
    public func player(_ player: YTSwiftyPlayer, didUpdateCurrentTime currentTime: Double) {
        
    }
    
    public func player(_ player: YTSwiftyPlayer, didChangePlaybackRate playbackRate: Double) {
        
    }
    
    public func playerReady(_ player: YTSwiftyPlayer) {
        
    }
    
    public func apiDidChange(_ player: YTSwiftyPlayer) {
        
    }
    
    public func youtubeIframeAPIReady(_ player: YTSwiftyPlayer) {
        
    }
    
    public func youtubeIframeAPIFailedToLoad(_ player: YTSwiftyPlayer) {
        
    }
}

