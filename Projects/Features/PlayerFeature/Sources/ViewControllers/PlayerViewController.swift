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

public class PlayerViewController: UIViewController {
    private let disposeBag = DisposeBag()
    var viewModel = PlayerViewModel()
    let playState = PlayState.shared
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
        self.youtubePlayerView.addSubview(playState.player)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        bindViewModel()
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
        
        bindCurrentPlayTime(output: output)
        bindTotalPlayTime(output: output)
        
        output.didPlay
            .asDriver(onErrorJustReturn: false)
            .filter { $0 }
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                if self.playState.state == .playing {
                    self.playState.pause()
                    self.playerView.playButton.setImage(DesignSystemAsset.Player.playLarge.image, for: .normal)
                    self.miniPlayerView.playButton.setImage(DesignSystemAsset.Player.miniPlay.image, for: .normal)
                } else {
                    self.playState.play()
                    self.playerView.playButton.setImage(DesignSystemAsset.Player.pause.image, for: .normal)
                    self.miniPlayerView.playButton.setImage(DesignSystemAsset.Player.miniPause.image, for: .normal)
                }
            })
            .disposed(by: disposeBag)

        output.didClose
            .asDriver(onErrorJustReturn: false)
            .filter { $0 }
            .drive(onNext: { [weak self] _ in
                print("didClose")
            })
            .disposed(by: disposeBag)
        
        output.didPrev
            .asDriver(onErrorJustReturn: false)
            .filter { $0 }
            .drive(onNext: { [weak self] _ in
                guard let self else { return }
                self.playState.backWard()
            })
            .disposed(by: disposeBag)
        
        output.didNext
            .asDriver(onErrorJustReturn: false)
            .filter { $0 }
            .drive(onNext: { [weak self] _ in
                guard let self else { return }
                self.playState.forWard()
            })
            .disposed(by: disposeBag)
        
    }
    
    private func bindCurrentPlayTime(output: PlayerViewModel.Output) {
        output.currentTimeText
            .asDriver()
            .drive(onNext: { [weak self] currentTimeText in
                guard let self else { return }
                self.playerView.currentPlayTimeLabel.text = currentTimeText
            })
            .disposed(by: self.disposeBag)
    }
    
    private func bindTotalPlayTime(output: PlayerViewModel.Output) {
        output.totalTimeText
            .asDriver()
            .drive(onNext: { [weak self] totalTimeText in
                guard let self else { return }
                self.playerView.totalPlayTimeLabel.text = totalTimeText
            })
            .disposed(by: self.disposeBag)
    }
}
