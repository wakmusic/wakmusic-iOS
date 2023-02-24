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
        playerView.lyricsTableView.delegate = self
        playerView.lyricsTableView.dataSource = self
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
        bindLyricsDidChangedEvent(output: output)
        bindLyricsTracking(output: output)
        
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
    
    private func bindLyricsDidChangedEvent(output: PlayerViewModel.Output) {
        output.lyricsDidChangedEvent.sink { [weak self] _ in
            guard let self else { return }
            self.playerView.lyricsTableView.reloadData()
        }
        .store(in: &subsciption)
    }
    
    private func bindLyricsTracking(output: PlayerViewModel.Output) {
        output.playTimeValue.sink { [weak self] value in
            guard let self else { return }
            let index = self.viewModel.getCurrentLyricsIndex(Int(value))
            guard self.viewModel.prevIndex != index else { return }
            self.updateLyricsTableViewCell(prev: self.viewModel.prevIndex, index: index)
            self.viewModel.prevIndex = index
        }
        .store(in: &subsciption)
    }
    
}

extension PlayerViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sortedLyrics.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LyricsTableViewCell.identifier, for: indexPath) as? LyricsTableViewCell
        else { return UITableViewCell() }
        cell.setLyrics(text: viewModel.sortedLyrics[indexPath.row])
        return cell
    }
    
    public func updateLyricsTableViewCell(prev: Int, index: Int) {
        if index < 0 { return }
        
        playerView.lyricsTableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: true)
            
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = playerView.lyricsTableView.cellForRow(at: indexPath) as? LyricsTableViewCell {
            
            (0..<viewModel.sortedLyrics.count).forEach {
                let idxPath = IndexPath(row: $0, section: 0)
                if let cell = playerView.lyricsTableView.cellForRow(at: idxPath) as? LyricsTableViewCell {
                    cell.highlight(false)
                }
            }
            cell.highlight(true)
        }
        
        guard prev >= 0 else { return }
        let prevIndexPath = IndexPath(row: prev, section: 0)
        if let prevCell = playerView.lyricsTableView.cellForRow(at: prevIndexPath) as? LyricsTableViewCell {
            prevCell.highlight(false)
        }
    }
    
}
