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
    
    var playlistComponent: PlaylistComponent!
    
    init(viewModel: PlayerViewModel, playlistComponent: PlaylistComponent) {
        self.viewModel = viewModel
        self.playlistComponent = playlistComponent
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
    
    func showPlaylist() {
        let playlistVC = playlistComponent.makeView()
        playlistVC.modalPresentationStyle = .fullScreen
        playlistVC.view.frame = self.view.frame
        self.present(playlistVC, animated: true)
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
            playlistButtonDidTapEvent: self.playerView.playistButton.tapPublisher,
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
        bindShowPlaylist(output: output)
        
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
        output.playTimeValue
            .compactMap { [weak self] value -> Int? in
                guard let self = self, value > 0, !self.viewModel.isLyricsScrolling else { return nil }
                return self.viewModel.getCurrentLyricsIndex(value)
            }
            .sink { [weak self] index in
                self?.updateLyricsHighlight(index: index)
            }
            .store(in: &subsciption)
    }
    
    private func bindShowPlaylist(output: PlayerViewModel.Output) {
        output.willShowPlaylist.sink { [weak self] _ in
            self?.showPlaylist()
        }.store(in: &subsciption)
    }
    
    private func updateLyricsHighlight(index: Int) {
        if !viewModel.isLyricsScrolling {
            playerView.lyricsTableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: true)
        }

        // 모든 셀에 대해서 강조 상태 업데이트
        let rows = playerView.lyricsTableView.numberOfRows(inSection: 0)
        for row in 0..<rows {
            let indexPath = IndexPath(row: row, section: 0)
            if let cell = playerView.lyricsTableView.cellForRow(at: indexPath) as? LyricsTableViewCell {
                cell.highlight(row == index)
            }
        }
    }
    
    /// 화면에서 가장 중앙에 위치한 셀의 indexPath를 찾습니다.
    private func findCenterCellIndexPath(completion: (_ centerCellIndexPath: IndexPath) -> Void) {
        let centerPoint = CGPoint(x: playerView.lyricsTableView.center.x,
                                  y: playerView.lyricsTableView.contentOffset.y + playerView.lyricsTableView.bounds.height / 2)
        // 가운데 셀의 IndexPath를 반환합니다.
        guard let centerCellIndexPath = playerView.lyricsTableView.indexPathForRow(at: centerPoint) else { return }
        completion(centerCellIndexPath)
    }
    
}

extension PlayerViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sortedLyrics.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LyricsTableViewCell.identifier, for: indexPath) as? LyricsTableViewCell
        else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.setLyrics(text: viewModel.sortedLyrics[indexPath.row])
        return cell
    }
    
    /// 스크롤뷰에서 드래그하기 시작할 때 한번만 호출
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        viewModel.isLyricsScrolling = true
    }
    
    /// 스크롤 중이면 계속 호출
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if viewModel.isLyricsScrolling {
            findCenterCellIndexPath { centerCellIndexPath in
                updateLyricsHighlight(index: centerCellIndexPath.row)
            }
        }
    }
    
    /// 손을 땠을 때 한번 호출, 테이블 뷰의 스크롤 모션의 감속 여부를 알 수 있다.
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            findCenterCellIndexPath { centerCellIndexPath in
                if viewModel.lyricsDict.isEmpty { return }
                let start = viewModel.lyricsDict.keys.sorted()[centerCellIndexPath.row]
                playState.player.seek(to: Double(start), allowSeekAhead: true)
                viewModel.isLyricsScrolling = false
            }
        }
    }
    
    /// 스크롤이 감속되고 멈춘 후에 작업을 처리
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        findCenterCellIndexPath { centerCellIndexPath in
            if viewModel.lyricsDict.isEmpty { return }
            let start = viewModel.lyricsDict.keys.sorted()[centerCellIndexPath.row]
            playState.player.seek(to: Double(start), allowSeekAhead: true)
            viewModel.isLyricsScrolling = false
        }
    }
     
}
