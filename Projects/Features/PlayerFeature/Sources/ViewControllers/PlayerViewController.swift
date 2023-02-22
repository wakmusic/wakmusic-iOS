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
    var viewModel: PlayerViewModel!
    let playState = PlayState.shared
    var playerView: PlayerView!
    var miniPlayerView: MiniPlayerView!
    
    var youtubePlayerView = UIView().then {
        $0.isHidden = false
    }
    
    init(viewModel: PlayerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("PlayerViewController init(coder:) has not been implemented")
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
            sliderValueChangedEvent: self.playerView.playTimeSlider.rx.value.changed.asObservable(),
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
        
        bindPlayerState(output: output)
        bindCurrentPlayTime(output: output)
        bindTotalPlayTime(output: output)
        
        output.didClose
            .asDriver(onErrorJustReturn: false)
            .filter { $0 }
            .drive(onNext: { _ in
                print("didClose")
            })
            .disposed(by: disposeBag)
        
    }
    
    private func bindPlayerState(output: PlayerViewModel.Output) {
        output.playerState
            .asDriver()
            .drive(onNext: { [weak self] state in
                guard let self else { return }
                switch state {
                case .unstarted: break
                case .ended: break
                case .playing:
                    self.playerView.playButton.setImage(DesignSystemAsset.Player.pause.image, for: .normal)
                    self.miniPlayerView.playButton.setImage(DesignSystemAsset.Player.miniPause.image, for: .normal)
                case .paused:
                    self.playerView.playButton.setImage(DesignSystemAsset.Player.playLarge.image, for: .normal)
                    self.miniPlayerView.playButton.setImage(DesignSystemAsset.Player.miniPlay.image, for: .normal)
                case .buffering: break
                case .cued: break
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    private func bindCurrentPlayTime(output: PlayerViewModel.Output) {
        output.playTimeText
            .asDriver()
            .drive(onNext: { [weak self] currentTimeText in
                guard let self else { return }
                self.playerView.currentPlayTimeLabel.text = currentTimeText
            })
            .disposed(by: self.disposeBag)
        
        output.playTimeValue
            .asDriver()
            .drive(onNext: { [weak self] value in
                guard let self else { return }
                self.playerView.playTimeSlider.value = value
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
        
        output.totalTimeValue
            .asDriver()
            .drive(onNext: { [weak self] value in
                guard let self else { return }
                self.playerView.playTimeSlider.minimumValue = 0
                self.playerView.playTimeSlider.maximumValue = value
            })
            .disposed(by: self.disposeBag)
    }
}
