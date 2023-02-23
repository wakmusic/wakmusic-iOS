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
import YouTubePlayerKit
import Combine
import Kingfisher

public class PlayerViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private var subsciption = Set<AnyCancellable>()
    var viewModel: PlayerViewModel!
    let playState = PlayState.shared
    var playerView: PlayerView!
    var miniPlayerView: MiniPlayerView!
    
    lazy var youtubePlayerView = YouTubePlayerHostingView(player: playState.player).then {
        $0.isHidden = true
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
        
        bindPlayButtonImages(output: output)
        bindThumbnail(output: output)
        bindTitle(output: output)
        bindArtist(output: output)
        bindCurrentPlayTime(output: output)
        bindTotalPlayTime(output: output)
        bindlikes(output: output)
        bindViews(output: output)
        
        output.didClose
            .asDriver(onErrorJustReturn: false)
            .filter { $0 }
            .drive(onNext: { _ in
                print("didClose")
            })
            .disposed(by: disposeBag)
        
    }
        
    private func bindPlayButtonImages(output: PlayerViewModel.Output) {
        output.playerState.sink { [weak self] state in
            guard let self else { return }
            switch state {
            case .playing:
                self.playerView.playButton.setImage(DesignSystemAsset.Player.pause.image, for: .normal)
                self.miniPlayerView.playButton.setImage(DesignSystemAsset.Player.miniPause.image, for: .normal)
            default:
                self.playerView.playButton.setImage(DesignSystemAsset.Player.playLarge.image, for: .normal)
                self.miniPlayerView.playButton.setImage(DesignSystemAsset.Player.miniPlay.image, for: .normal)
            }
        }.store(in: &subsciption)
    }
    
    private func bindThumbnail(output: PlayerViewModel.Output) {
        output.thumbnailImageURL.sink { [weak self] thumbnailImageURL in
            guard let self else { return }
            self.playerView.thumbnailImageView.kf.setImage(with: URL(string: thumbnailImageURL))
            self.playerView.backgroundImageView.kf.setImage(with: URL(string: thumbnailImageURL))
            self.miniPlayerView.thumbnailImageView.kf.setImage(with: URL(string: thumbnailImageURL))
        }.store(in: &subsciption)
    }
    
    private func bindTitle(output: PlayerViewModel.Output) {
        output.titleText.sink { [weak self] titleText in
            guard let self else { return }
            self.playerView.titleLabel.text = titleText
            self.miniPlayerView.titleLabel.text = titleText
        }.store(in: &subsciption)
    }
    
    private func bindArtist(output: PlayerViewModel.Output) {
        output.artistText.sink { [weak self] artistText in
            guard let self else { return }
            self.playerView.artistLabel.text = artistText
            self.miniPlayerView.artistLabel.text = artistText
        }
        .store(in: &subsciption)
    }
    
    private func bindlikes(output: PlayerViewModel.Output) {
        output.likeCountText.sink { [weak self] likeCountText in
            guard let self else { return }
            self.playerView.likeButton.setTitle(likeCountText, for: .normal)
        }
        .store(in: &subsciption)
    }
    
    private func bindViews(output: PlayerViewModel.Output) {
        output.viewsCountText.sink { [weak self] viewsCountText in
            guard let self else { return }
            self.playerView.viewsLabel.text = viewsCountText
        }
        .store(in: &subsciption)
    }
    
    private func bindCurrentPlayTime(output: PlayerViewModel.Output) {
        output.playTimeText.sink { [weak self] currentTimeText in
            guard let self else { return }
            self.playerView.currentPlayTimeLabel.text = currentTimeText
            self.miniPlayerView.currentPlayTimeView.snp.remakeConstraints {
                let playTimeValue = output.playTimeValue.value
                let totalTimeValue = output.totalTimeValue.value
                let newValue = totalTimeValue == 0 ? 0 : playTimeValue / totalTimeValue
                $0.top.left.bottom.equalToSuperview()
                $0.width.equalTo(self.miniPlayerView.totalPlayTimeView.snp.width).multipliedBy(newValue)
            }
        }
        .store(in: &subsciption)
        
        output.playTimeValue.sink { [weak self] value in
            guard let self else { return }
            self.playerView.playTimeSlider.value = value
        }
        .store(in: &subsciption)
    }
    
    private func bindTotalPlayTime(output: PlayerViewModel.Output) {
        output.totalTimeText.sink { [weak self] totalTimeText in
            guard let self else { return }
            self.playerView.totalPlayTimeLabel.text = totalTimeText
        }
        .store(in: &subsciption)
        
        output.totalTimeValue.sink { [weak self] value in
            guard let self else { return }
            self.playerView.playTimeSlider.minimumValue = 0
            self.playerView.playTimeSlider.maximumValue = value
        }
        .store(in: &subsciption)
    }
}
