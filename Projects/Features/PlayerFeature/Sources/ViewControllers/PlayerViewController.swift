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
import PanModal
import CommonFeature

public class PlayerViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private var subscription = Set<AnyCancellable>()
    var viewModel: PlayerViewModel!
    let playState = PlayState.shared
    var playerView: PlayerView!
    var miniPlayerView: MiniPlayerView!
    
    lazy var youtubePlayerView = YouTubePlayerHostingView(player: playState.player ?? YouTubePlayer()).then {
        $0.isHidden = true
    }
    
    internal var playlistComponent: PlaylistComponent!
    internal var containSongsComponent: ContainSongsComponent!
    
    init(viewModel: PlayerViewModel, playlistComponent: PlaylistComponent, containSongsComponent: ContainSongsComponent) {
        self.viewModel = viewModel
        self.playlistComponent = playlistComponent
        self.containSongsComponent = containSongsComponent
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("PlayerViewController init(coder:) has not been implemented")
    }
    
    deinit {
        DEBUG_LOG("플레이어 뷰컨 deinit")
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
            $0.width.equalTo(self.playerView.thumbnailImageView.snp.width)
            $0.height.equalTo(self.playerView.thumbnailImageView.snp.height)
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        DEBUG_LOG("viewDidLoad")
        playerView.lyricsTableView.delegate = self
        playerView.lyricsTableView.dataSource = self
        bindViewModel()
        bindNotification()
    }
    
    func showPlaylist() {
        let playlistVC = playlistComponent.makeView()
        playlistVC.modalPresentationStyle = .overFullScreen
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
    private func bindNotification() {
        NotificationCenter.default.rx
            .notification(.resetYouTubePlayerHostingView)
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.resetYouTubePlayerHostingView()
            }).disposed(by: disposeBag)
    }
    
    private func resetYouTubePlayerHostingView() {
        self.youtubePlayerView.removeFromSuperview()
        self.youtubePlayerView = YouTubePlayerHostingView(player: self.playState.player ?? YouTubePlayer())
        self.youtubePlayerView.isHidden = true
        self.view.addSubview(self.youtubePlayerView)
        self.youtubePlayerView.snp.makeConstraints {
            $0.centerX.centerY.equalTo(self.playerView.thumbnailImageView)
            $0.width.equalTo(self.playerView.thumbnailImageView.snp.width)
            $0.height.equalTo(self.playerView.thumbnailImageView.snp.height)
        }
        PlayState.shared.subscribePlayPublisher()
    }
    
    private func bindViewModel() {
        let input = PlayerViewModel.Input(
            viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map {_ in },
            closeButtonDidTapEvent: self.playerView.closeButton.tapPublisher(),
            playButtonDidTapEvent: Publishers.Merge(
                self.playerView.playButton.tapPublisher(),
                self.miniPlayerView.playButton.tapPublisher()
            ).eraseToAnyPublisher(),
            prevButtonDidTapEvent: self.playerView.prevButton.rx.tap.asObservable(),
            nextButtonDidTapEvent: Observable.merge(
                self.playerView.nextButton.rx.tap.asObservable(),
                self.miniPlayerView.nextButton.rx.tap.asObservable()
            ),
            sliderValueChangedEvent: self.playerView.playTimeSlider.rx.value.changed.asObservable(),
            repeatButtonDidTapEvent: self.playerView.repeatButton.tapPublisher(),
            shuffleButtonDidTapEvent: self.playerView.shuffleButton.tapPublisher(),
            likeButtonDidTapEvent: self.playerView.likeButton.tapPublisher(),
            addPlaylistButtonDidTapEvent: self.playerView.addPlayistButton.tapPublisher(),
            playlistButtonDidTapEvent: Publishers.Merge(
                self.playerView.playistButton.tapPublisher(),
                self.miniPlayerView.playlistButton.tapPublisher()
            ).eraseToAnyPublisher(),
            miniExtendButtonDidTapEvent: self.miniPlayerView.extendButton.tapPublisher()
        )
        let output = self.viewModel.transform(from: input)
        
        bindPlayButtonImages(output: output)
        bindThumbnail(output: output)
        bindTitle(output: output)
        bindArtist(output: output)
        bindCurrentPlayTime(output: output)
        bindTotalPlayTime(output: output)
        bindMiniPlayerSlider(output: output)
        bindlikes(output: output)
        bindViews(output: output)
        bindLyricsDidChangedEvent(output: output)
        bindLyricsTracking(output: output)
        bindRepeatMode(output: output)
        bindShuffleMode(output: output)
        bindShowPlaylist(output: output)
        bindShowToastMessage(output: output)
        bindShowConfirmModal(output: output)
        bindShowContainSongsViewController(output: output)
        bindShowTokenModal(output: output)
    }
    
    private func bindShowTokenModal(output: PlayerViewModel.Output){
        output.showTokenModal.sink { [weak self] message in
            self?.showPanModal(
                content: TextPopupViewController.viewController(
                    text: message,
                    cancelButtonIsHidden: true,
                    completion: {
                        LOGOUT()
                        self?.playState.switchPlayerMode(to: .mini)
                    }
                )
            )
        }
        .store(in: &subscription)
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
        }.store(in: &subscription)
    }
    
    private func bindThumbnail(output: PlayerViewModel.Output) {
        output.thumbnailImageURL.sink { [weak self] thumbnailImageURL in
            guard let self else { return }
            let placeholderImage = DesignSystemAsset.Logo.placeHolderLarge.image
            let transitionOptions: KingfisherOptionsInfo = [.transition(.fade(0.2))]
            
            let hdURL = URL(string: thumbnailImageURL.hdQuality)
            let sdURL = URL(string: thumbnailImageURL.sdQuality)
            
            self.playerView.thumbnailImageView.kf.setImage(
                with: hdURL,
                placeholder: placeholderImage,
                options: transitionOptions,
                completionHandler: { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success:
                        break
                    case .failure(let error):
                        guard error.errorCode == 2002 else { return } //invalidHTTPStatusCode
                        DEBUG_LOG("👽:: \(thumbnailImageURL.hdQuality)\n\(error.localizedDescription)")
                        self.playerView.thumbnailImageView.kf.setImage(
                            with: sdURL,
                            placeholder: placeholderImage,
                            options: transitionOptions
                        )
                    }
                }
            )
            self.playerView.backgroundImageView.kf.setImage(
                with: sdURL,
                placeholder: placeholderImage,
                options: transitionOptions
            )
        }.store(in: &subscription)
    }
    
    private func bindTitle(output: PlayerViewModel.Output) {
        output.titleText.sink { [weak self] titleText in
            guard let self else { return }
            self.playerView.titleLabel.text = titleText
            self.miniPlayerView.titleLabel.text = titleText
        }.store(in: &subscription)
    }
    
    private func bindArtist(output: PlayerViewModel.Output) {
        output.artistText.sink { [weak self] artistText in
            guard let self else { return }
            self.playerView.artistLabel.text = artistText
            self.miniPlayerView.artistLabel.text = artistText
        }
        .store(in: &subscription)
    }
    
    private func bindlikes(output: PlayerViewModel.Output) {
        output.likeCountText.sink { [weak self] likeCountText in
            guard let self else { return }
            self.playerView.likeButton.title = likeCountText
        }
        .store(in: &subscription)
        
        output.likeState.sink { [weak self] isLiked in
            guard let self else { return }
            self.playerView.likeButton.isLiked = isLiked
        }.store(in: &subscription)
    }
    
    private func bindViews(output: PlayerViewModel.Output) {
        output.viewsCountText.sink { [weak self] viewsCountText in
            guard let self else { return }
            self.playerView.viewsView.title = viewsCountText
        }
        .store(in: &subscription)
    }
    
    private func bindCurrentPlayTime(output: PlayerViewModel.Output) {
        output.playTimeText.sink { [weak self] currentTimeText in
            guard let self else { return }
            self.playerView.currentPlayTimeLabel.text = currentTimeText
        }
        .store(in: &subscription)
        
        output.playTimeValue.sink { [weak self] value in
            guard let self else { return }
            self.playerView.playTimeSlider.value = value
        }
        .store(in: &subscription)
    }
    
    private func bindTotalPlayTime(output: PlayerViewModel.Output) {
        output.totalTimeText.sink { [weak self] totalTimeText in
            guard let self else { return }
            self.playerView.totalPlayTimeLabel.text = totalTimeText
        }
        .store(in: &subscription)
        
        output.totalTimeValue.sink { [weak self] value in
            guard let self else { return }
            self.playerView.playTimeSlider.minimumValue = 0
            self.playerView.playTimeSlider.maximumValue = value
        }
        .store(in: &subscription)
    }
    
    private func bindMiniPlayerSlider(output: PlayerViewModel.Output) {
        output.playTimeValue.combineLatest(output.totalTimeValue)
            .map({ (playTimeValue, totalTimeValue) in
                return totalTimeValue == 0 ? 0 : playTimeValue / totalTimeValue
            })
            .sink { [weak self] newValue in
                guard let self else { return }
                self.miniPlayerView.currentPlayTimeView.snp.remakeConstraints {
                    $0.top.left.bottom.equalToSuperview()
                    $0.width.equalTo(self.miniPlayerView.totalPlayTimeView.snp.width).multipliedBy(newValue)
                }
            }
            .store(in: &subscription)
    }
    
    private func bindLyricsDidChangedEvent(output: PlayerViewModel.Output) {
        output.lyricsDidChangedEvent.sink { [weak self] _ in
            guard let self else { return }
            self.playerView.lyricsTableView.reloadData()
        }
        .store(in: &subscription)
    }
    
    private func bindLyricsTracking(output: PlayerViewModel.Output) {
        output.playTimeValue
            .compactMap { [weak self] time -> Int? in
                guard let self = self, time > 0,
                        !self.viewModel.lyricsDict.isEmpty,
                        !self.viewModel.isLyricsScrolling else { return nil }
                return self.viewModel.getCurrentLyricsIndex(time)
            }
            .sink { [weak self] index in
                self?.updateLyricsHighlight(index: index)
            }
            .store(in: &subscription)
    }
    
    private func bindShowPlaylist(output: PlayerViewModel.Output) {
        output.willShowPlaylist.sink { [weak self] _ in
            self?.showPlaylist()
        }.store(in: &subscription)
    }
    
    private func bindRepeatMode(output: PlayerViewModel.Output) {
        output.repeatMode.sink { [weak self] repeatMode in
            guard let self else { return }
            switch repeatMode {
            case .none:
                self.playerView.repeatButton.setImage(DesignSystemAsset.Player.repeatOff.image, for: .normal)
            case .repeatAll:
                self.playerView.repeatButton.setImage(DesignSystemAsset.Player.repeatOnAll.image, for: .normal)
            case .repeatOnce:
                self.playerView.repeatButton.setImage(DesignSystemAsset.Player.repeatOn1.image, for: .normal)
            }
        }.store(in: &subscription)
    }
    
    private func bindShuffleMode(output: PlayerViewModel.Output) {
        output.shuffleMode.sink { [weak self] shuffleMode in
            guard let self else { return }
            switch shuffleMode {
            case .off:
                self.playerView.shuffleButton.setImage(DesignSystemAsset.Player.shuffleOff.image, for: .normal)
            case .on:
                self.playerView.shuffleButton.setImage(DesignSystemAsset.Player.shuffleOn.image, for: .normal)
            }
        }.store(in: &subscription)
    }
    
    private func bindShowToastMessage(output: PlayerViewModel.Output) {
        output.showToastMessage.sink { [weak self] message in
            self?.showToast(text: message, font: DesignSystemFontFamily.Pretendard.light.font(size: 14))
        }.store(in: &subscription)
    }
    
    private func bindShowConfirmModal(output: PlayerViewModel.Output) {
        output.showConfirmModal.sink { [weak self] message in
            self?.showPanModal(content: TextPopupViewController.viewController(text: message, cancelButtonIsHidden: false, completion: {
                NotificationCenter.default.post(name: .movedTab, object: 4) // 보관함 탭으로 이동
                self?.playState.switchPlayerMode(to: .mini)
            }, cancelCompletion: {
            }))
        }.store(in: &subscription)
    }
    
    private func bindShowContainSongsViewController(output: PlayerViewModel.Output) {
        output.showContainSongsViewController.sink { [weak self] songId in
            guard let self else { return }
            let viewController = self.containSongsComponent.makeView(songs: [songId])
            viewController.modalPresentationStyle = .overFullScreen
            self.present(viewController, animated: true)
        }.store(in: &subscription)
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
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LyricsTableViewCell.getCellHeight(lyric: viewModel.sortedLyrics[indexPath.row])
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
                playState.player?.seek(to: Double(start), allowSeekAhead: true)
                viewModel.isLyricsScrolling = false
            }
        }
    }
    
    /// 스크롤이 감속되고 멈춘 후에 작업을 처리
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        findCenterCellIndexPath { centerCellIndexPath in
            if viewModel.lyricsDict.isEmpty { return }
            let start = viewModel.lyricsDict.keys.sorted()[centerCellIndexPath.row]
            playState.player?.seek(to: Double(start), allowSeekAhead: true)
            viewModel.isLyricsScrolling = false
        }
    }
}
