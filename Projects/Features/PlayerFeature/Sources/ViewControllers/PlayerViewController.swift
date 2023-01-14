//
//  PlayerViewController.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/01/09.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import SwiftUI
import Utility
import DesignSystem
import SnapKit
import Then
import RxCocoa
import RxSwift
import YoutubeKit
import WebKit

public class PlayerViewController: UIViewController {
    private let disposeBag = DisposeBag()
    var viewModel = PlayerViewModel()
    private var player: YTSwiftyPlayer!
    
    var playerView: PlayerView!
    var miniPlayerView: MiniPlayerView!
    
    var youtubePlayerView: UIView = UIView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        bindUI()
        
        // Create a new player
        player = YTSwiftyPlayer(
            frame: .zero,
            playerVars: [
                .playsInline(false),
                .videoID("pyRHIRVapcE"),
                .loopVideo(true),
                .showRelatedVideo(false),
                .autoplay(true)
            ])
        print(player)
        view.addSubview(youtubePlayerView)
        youtubePlayerView.snp.makeConstraints {
            $0.edges.equalTo(playerView.thumbnailImageView.snp.edges)
        }
        youtubePlayerView.backgroundColor = .yellow
        youtubePlayerView = player
        player.delegate = self
        //player.loadDefaultPlayer()
        player.loadVideo(videoID: "pyRHIRVapcE")
    }
    
    public override func loadView() {
        super.loadView()
        
        playerView = PlayerView(frame: self.view.frame)
        miniPlayerView = MiniPlayerView(frame: self.view.frame)
        miniPlayerView.layer.opacity = 0
        self.view.addSubview(playerView)
        self.view.addSubview(miniPlayerView)
    }
}

public extension PlayerViewController {
    func updateOpacity(value: Float) {
        playerView.layer.opacity = value
        miniPlayerView.layer.opacity = 1 - value
    }
}

extension PlayerViewController: YTSwiftyPlayerDelegate {
    public func playerReady(_ player: YTSwiftyPlayer) {
        print(#function)
        // Player API is available after loading a video.
        // e.g. player.mute()
    }
    
    public func player(_ player: YTSwiftyPlayer, didUpdateCurrentTime currentTime: Double) {
        print("\(#function): \(currentTime)")
    }
    
    public func player(_ player: YTSwiftyPlayer, didChangeState state: YTSwiftyPlayerState) {
        print("\(#function): \(state)")
    }
    
    public func player(_ player: YTSwiftyPlayer, didChangePlaybackRate playbackRate: Double) {
        print("\(#function): \(playbackRate)")
    }
    
    public func player(_ player: YTSwiftyPlayer, didReceiveError error: YTSwiftyPlayerError) {
        print("\(#function): \(error)")
    }
    
    public func player(_ player: YTSwiftyPlayer, didChangeQuality quality: YTSwiftyVideoQuality) {
        print("\(#function): \(quality)")
    }
    
    public func apiDidChange(_ player: YTSwiftyPlayer) {
        print(#function)
    }
    
    public func youtubeIframeAPIReady(_ player: YTSwiftyPlayer) {
        print(#function)
    }
    
    public func youtubeIframeAPIFailedToLoad(_ player: YTSwiftyPlayer) {
        print(#function)
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
    }
    
    private func bindUI() {
    }
}

struct NewPlayerViewController_Previews: PreviewProvider {
    static var previews: some View {
        PlayerViewController().toPreview()
    }
}
