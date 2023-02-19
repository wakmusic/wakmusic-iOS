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

public class PlayerViewController: UIViewController {
    private let disposeBag = DisposeBag()
    var viewModel = PlayerViewModel()
//    var youtubePlayer: YouTubePlayer?
    private var youtubePlayer: YTSwiftyPlayer!
    var playerView: PlayerView!
    var miniPlayerView: MiniPlayerView!
    
    var youtubePlayerView = UIView()
    let htmlStr = """
    <!DOCTYPE html>
    <html>
    <head>
        <style>
            html, body { margin: 0; padding: 0; width: 100%; height: 100%; background-color: #000000; }
        </style>
    </head>
    <body>
        <div id="player"></div>
        <div id="explain"></div>
        <script src="https://www.youtube.com/iframe_api" onerror="webkit.messageHandlers.onYouTubeIframeAPIFailedToLoad.postMessage('')"></script>
        <script>
            var player;
            var time;
            YT.ready(function() {
                     player = new YT.Player('player', %@);
                     webkit.messageHandlers.onYouTubeIframeAPIReady.postMessage('');
                     function updateTime() {
                         var state = player.getPlayerState();
                         if (state == YT.PlayerState.PLAYING) {
                            time = player.getCurrentTime();
                            webkit.messageHandlers.onUpdateCurrentTime.postMessage(time);
                         }
                     }
                     window.setInterval(updateTime, 500);
                     });
                     function onReady(event) {
                         webkit.messageHandlers.onReady.postMessage('');
                     }
        function onStateChange(event) {
            webkit.messageHandlers.onStateChange.postMessage(event.data);
        }
        function onPlaybackQualityChange(event) {
            webkit.messageHandlers.onPlaybackQualityChange.postMessage(event.data);
        }
        function onPlaybackRateChange(event) {
            webkit.messageHandlers.onPlaybackRateChange.postMessage(event.data);
        }
        function onError(event) {
            webkit.messageHandlers.onError.postMessage(event.data);
        }
        function onApiChange(event) {
            webkit.messageHandlers.onApiChange.postMessage(event.data);
        }
        </script>
    </body>
    </html>

    """

    public override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        setupYoutubePlayer()
        bindViewModel()
        bindUI()
    }
    
    func setupYoutubePlayer() {
        //        let configuration = YouTubePlayer.Configuration(
        //            autoPlay: true,
        //            showControls: false,
        //            loopEnabled: true,
        //            showRelatedVideos: false
        //        )
        //
        //        self.youtubePlayer = YouTubePlayer(
        //            source: .video(id: "fgSXAKsq-Vo"),
        //            configuration: configuration
        //        )
        
        //        guard var youtubePlayer = self.youtubePlayer else { return }
        
        //        self.youtubePlayerView = YouTubePlayerHostingView(player: youtubePlayer)
        
        self.view.addSubview(self.youtubePlayerView)
        
        self.youtubePlayerView.snp.makeConstraints {
            $0.centerX.centerY.equalTo(self.playerView.thumbnailImageView)
            $0.width.equalTo(320)
            $0.height.equalTo(180)
        }
        self.youtubePlayerView.isHidden = true
        self.youtubePlayer = YTSwiftyPlayer(
            frame: .init(x: 0, y: 0, width: 320, height: 190),
            playerVars: [
                .playsInline(true),
                .loopVideo(true),
                .showRelatedVideo(false),
                .autoplay(true)
            ])
        self.youtubePlayerView.addSubview(youtubePlayer)
        youtubePlayer.delegate = self
//        // Load video player
//        let playerPath = YoutubeKitResources.bundle
//            .path(forResource: "player", ofType: "html")!
//        let htmlString = (try? String(contentsOfFile: playerPath, encoding: .utf8)) ?? ""
        self.youtubePlayer.loadVideo(videoID: "fgSXAKsq-Vo")

        youtubePlayer.loadPlayerHTML(htmlStr)
//        youtubePlayer.loadDefaultPlayer()

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

struct NewPlayerViewController_Previews: PreviewProvider {
    static var previews: some View {
        PlayerViewController().toPreview()
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

