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

public class PlayerViewController: UIViewController {
    private let disposeBag = DisposeBag()
    var viewModel = PlayerViewModel()
    var youTubePlayer = YouTubePlayer(configuration: .init(autoPlay: true, showControls: false, showRelatedVideos: false))
    var playerView: PlayerView!
    var miniPlayerView: MiniPlayerView!
    
    var youtubePlayerView: UIView!

    public override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        bindUI()
        setupYoutubePlayer()
        
    }
    
    func setupYoutubePlayer() {
        youtubePlayerView = YouTubePlayerHostingView(player: youTubePlayer)
        self.view.addSubview(youtubePlayerView)
        youtubePlayerView.snp.makeConstraints {
            $0.centerX.centerY.equalTo(playerView.thumbnailImageView)
            $0.width.equalTo(320)
            $0.height.equalTo(180)
        }
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
                //self?.youTubePlayer.load(source: .video(id: "fgSXAKsq-Vo"))
                self?.youTubePlayer.load(source: .url("https://youtube.com/watch?v=fgSXAKsq-Vo"))
            })
            .disposed(by: disposeBag)
        
        output.didClose
            .asDriver(onErrorJustReturn: false)
            .filter { $0 }
            .drive(onNext: { [weak self] _ in
                print("didClose")
                self?.youTubePlayer.stop()
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
