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
import Combine

public class PlayerViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private var anyCancellable = Set<AnyCancellable>()
    var viewModel = PlayerViewModel()
    var youtubePlayer: YouTubePlayer!
    var playerView: PlayerView!
    var miniPlayerView: MiniPlayerView!
    
    var youtubePlayerView: UIView!
    
    public override func loadView() {
        super.loadView()
        playerView = PlayerView(frame: self.view.frame)
        miniPlayerView = MiniPlayerView(frame: self.view.frame)
        miniPlayerView.layer.opacity = 0
        self.view.addSubview(playerView)
        self.view.addSubview(miniPlayerView)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        //bindViewModel()
        setupYoutubePlayer()
        bindUI()
    }
    
    func setupYoutubePlayer() {
        let configuration = YouTubePlayer.Configuration(
            autoPlay: true,
            showControls: false,
            loopEnabled: true,
            showRelatedVideos: false
        )
        
        self.youtubePlayer = YouTubePlayer(
            source: .video(id: "fgSXAKsq-Vo"),
            configuration: configuration
        )
        
        guard let youtubePlayer = self.youtubePlayer else { return }
        
        self.youtubePlayerView = YouTubePlayerHostingView(player: youtubePlayer)
        
        self.view.addSubview(self.youtubePlayerView)
        self.youtubePlayerView.snp.makeConstraints {
            $0.centerX.centerY.equalTo(self.playerView.thumbnailImageView)
            $0.width.equalTo(320)
            $0.height.equalTo(180)
        }
        
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
                guard let self = self else { return }
                guard let youtubePlayer = self.youtubePlayer else { return }
                print("didPlay")
                youtubePlayer.load(source: .video(id: "1hcdQixxJdA"))
            })
            .disposed(by: disposeBag)
        
        output.didClose
            .asDriver(onErrorJustReturn: false)
            .filter { $0 }
            .drive(onNext: { [weak self] _ in
                print("didClose")
                self?.youtubePlayer?.stop()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
        self.playerView.playButton.rx.tap.bind { _ in
            print("clicked")
            //self.youtubePlayer.load(source: .video(id: "1hcdQixxJdA"))
            
            self.youtubePlayer.play()
        }.disposed(by: disposeBag)
        
        self.youtubePlayer.$source.sink { print($0?.id) }.store(in: &anyCancellable)

    }
}
