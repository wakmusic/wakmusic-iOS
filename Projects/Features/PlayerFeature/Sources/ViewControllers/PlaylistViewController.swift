//
//  PlaylistViewController.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/02/28.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import UIKit
import Combine
import Kingfisher
import SnapKit
import DesignSystem
import Utility
import CommonFeature
import RxSwift
import RxRelay
import RxDataSources
import DomainModule

public class PlaylistViewController: UIViewController, SongCartViewType {
    var viewModel: PlaylistViewModel!
    var playlistView: PlaylistView!
    var playState = PlayState.shared
    var subscription = Set<AnyCancellable>()
    var disposeBag = DisposeBag()
    
    var tappedCellIndex = PublishSubject<Int>()
    var isSelectedAllSongs = PublishSubject<Bool>()
    var tappedAddPlaylist = PublishSubject<Void>()
    var tappedRemoveSongs = PublishSubject<Void>()
    
    internal var containSongsComponent: ContainSongsComponent!
    
    public var songCartView: CommonFeature.SongCartView!
    public var bottomSheetView: CommonFeature.BottomSheetView!
    
    init(viewModel: PlaylistViewModel, containSongsComponent: ContainSongsComponent) {
        self.viewModel = viewModel
        self.containSongsComponent = containSongsComponent
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        DEBUG_LOG("❌ PlaylistVC deinit")
    }
    
    required init?(coder: NSCoder) {
        fatalError("PlaylistViewController has not been implemented")
    }
    
    public override func loadView() {
        super.loadView()
        playlistView = PlaylistView(frame: self.view.frame)
        self.view.addSubview(playlistView)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        playlistView.playlistTableView.rx.setDelegate(self).disposed(by: disposeBag)
        bindViewModel()
        bindActions()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Comment: 재생목록 화면이 사라지는 시점에서 DB에 저장된 리스트로 업데이트
        //편집 완료를 했으면 이미 DB가 업데이트 됐을거고, 아니면 이전 DB데이터로 업데이트
        self.playState.playList.list = self.playState.fetchPlayListFromLocalDB()
        //Comment: 재생목록 화면이 사라지는 시점에서 곡 담기 팝업이 올라와 있는 상태면 제거
        guard self.songCartView != nil else { return }
        self.hideSongCart()
    }
}

private extension PlaylistViewController {
    private func bindViewModel() {
        let input = PlaylistViewModel.Input(
            closeButtonDidTapEvent: playlistView.closeButton.tapPublisher,
            editButtonDidTapEvent: playlistView.editButton.tapPublisher,
            repeatButtonDidTapEvent: playlistView.repeatButton.tapPublisher,
            prevButtonDidTapEvent: playlistView.prevButton.tapPublisher,
            playButtonDidTapEvent: playlistView.playButton.tapPublisher,
            nextButtonDidTapEvent: playlistView.nextButton.tapPublisher,
            shuffleButtonDidTapEvent: playlistView.shuffleButton.tapPublisher,
            playlistTableviewCellDidTapEvent: playlistView.playlistTableView.rx.itemSelected.asObservable(),
            playlistTableviewCellDidTapInEditModeEvent: tappedCellIndex.asObservable(),
            selectAllSongsButtonDidTapEvent: isSelectedAllSongs.asObservable(),
            addPlaylistButtonDidTapEvent: tappedAddPlaylist.asObservable(),
            removeSongsButtonDidTapEvent: tappedRemoveSongs.asObservable(),
            itemMovedEvent: playlistView.playlistTableView.rx.itemMoved.asObservable()
        )
        let output = self.viewModel.transform(from: input)
        
        bindPlaylistTableView(output: output)
        bindSongCart(output: output)
        bindCloseButton(output: output)
        bindThumbnail(output: output)
        bindCurrentPlayTime(output: output)
        bindRepeatMode(output: output)
        bindShuffleMode(output: output)
        bindPlayButtonImages(output: output)
        bindwaveStreamAnimationView(output: output)
    }
    
    private func bindPlaylistTableView(output: PlaylistViewModel.Output) {
        output.editState.sink { [weak self] isEditing in
            guard let self else { return }
            self.playlistView.titleLabel.text = isEditing ? "재생목록 편집" : "재생목록"
            self.playlistView.editButton.setTitle(isEditing ? "완료" : "편집", for: .normal)
            self.playlistView.editButton.setColor(isHighlight: isEditing)
            self.playlistView.playlistTableView.setEditing(isEditing, animated: true)
            self.playlistView.playlistTableView.reloadData()
        }.store(in: &subscription)
        
        output.currentSongIndex.sink { [weak self] _ in
            self?.playlistView.playlistTableView.reloadData()
        }.store(in: &subscription)
        
        output.dataSource
            .bind(to: playlistView.playlistTableView.rx.items(dataSource: createDatasources(output: output)))
            .disposed(by: disposeBag)
        
        output.dataSource
            .filter { $0.first?.items.isEmpty ?? true }
            .subscribe { [weak self] _ in
                let space = APP_HEIGHT() - STATUS_BAR_HEGHIT() - 48 - 56 - SAFEAREA_BOTTOM_HEIGHT()
                let height = space / 3  * 2
                let warningView = WarningView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: height))
                warningView.text = "곡이 없습니다."
                self?.playlistView.playlistTableView.tableFooterView = warningView
            }.disposed(by: disposeBag)
        
        output.dataSource
            .map { return $0.first?.items.isEmpty ?? true }
            .bind(to: playlistView.editButton.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func bindSongCart(output: PlaylistViewModel.Output) {
        output.indexOfSelectedSongs
            .skip(1)
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .map({ (songs, dataSource) -> (songs: [Int], dataSourceCount: Int) in
                return (songs, dataSource.first?.items.count ?? 0)
            })
            .subscribe(onNext: { [weak self] (songs, dataSourceCount) in
                guard let self = self else { return }
                switch songs.isEmpty {
                case true :
                    self.hideSongCart()
                case false:
                    self.showSongCart(
                        in: self.view,
                        type: .playList,
                        selectedSongCount: songs.count,
                        totalSongCount: dataSourceCount,
                        useBottomSpace: true
                    )
                    self.songCartView?.delegate = self
                }
            }).disposed(by: disposeBag)
    }
    
    private func bindCloseButton(output: PlaylistViewModel.Output) {
        output.willClosePlaylist.sink { [weak self] _ in
            self?.dismiss(animated: true)
        }.store(in: &subscription)
    }
    
    private func bindThumbnail(output: PlaylistViewModel.Output) {
        output.thumbnailImageURL
            .sink { [weak self] thumbnailImageURL in
            self?.playlistView.thumbnailImageView.kf.setImage(
                with: URL(string: thumbnailImageURL),
                placeholder: DesignSystemAsset.Logo.placeHolderSmall.image,
                options: [.transition(.fade(0.2))])
        }.store(in: &subscription)
    }
    
    private func bindCurrentPlayTime(output: PlaylistViewModel.Output) {
        output.playTimeValue.combineLatest(output.totalTimeValue)
            .compactMap { (playTimeValue, totalTimeValue) -> Float? in
                guard totalTimeValue > 0 else { return nil }
                let newRatio = playTimeValue / totalTimeValue
                return newRatio
            }
            .sink { [weak self] newRatio in
                guard let self else { return }
                self.playlistView.currentPlayTimeView.snp.remakeConstraints {
                    $0.top.left.bottom.equalToSuperview()
                    $0.width.equalTo(self.playlistView.totalPlayTimeView.snp.width).multipliedBy(newRatio)
                }
            }
            .store(in: &subscription)
    }
    
    private func bindRepeatMode(output: PlaylistViewModel.Output) {
        output.repeatMode.sink { [weak self] repeatMode in
            guard let self else { return }
            switch repeatMode {
            case .none:
                self.playlistView.repeatButton.setImage(DesignSystemAsset.Player.repeatOff.image, for: .normal)
            case .repeatAll:
                self.playlistView.repeatButton.setImage(DesignSystemAsset.Player.repeatOnAll.image, for: .normal)
            case .repeatOnce:
                self.playlistView.repeatButton.setImage(DesignSystemAsset.Player.repeatOn1.image, for: .normal)
            }
        }.store(in: &subscription)
    }
    
    private func bindShuffleMode(output: PlaylistViewModel.Output) {
        output.shuffleMode.sink { [weak self] shuffleMode in
            guard let self else { return }
            switch shuffleMode {
            case .off:
                self.playlistView.shuffleButton.setImage(DesignSystemAsset.Player.shuffleOff.image, for: .normal)
            case .on:
                self.playlistView.shuffleButton.setImage(DesignSystemAsset.Player.shuffleOn.image, for: .normal)
            }
        }.store(in: &subscription)
    }
    
    private func bindPlayButtonImages(output: PlaylistViewModel.Output) {
        output.playerState.sink { [weak self] state in
            guard let self else { return }
            switch state {
            case .playing:
                self.playlistView.playButton.setImage(DesignSystemAsset.Player.miniPause.image, for: .normal)
            default:
                self.playlistView.playButton.setImage(DesignSystemAsset.Player.miniPlay.image, for: .normal)
            }
        }.store(in: &subscription)
    }
    
    private func bindwaveStreamAnimationView(output: PlaylistViewModel.Output) {
        output.playerState
            .compactMap { [weak self] state -> (PlaylistTableViewCell, Bool)? in
                guard let self else { return nil }
                guard let index = self.playState.playList.currentPlayIndex else { return nil }
                guard let cell = self.playlistView.playlistTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? PlaylistTableViewCell else { return nil }
                return (cell, state == .playing)
            }
            .sink { cell, isAnimating in
                if isAnimating {
                    cell.waveStreamAnimationView.play()
                } else {
                    cell.waveStreamAnimationView.pause()
                }
            }
            .store(in: &subscription)
    }
}

private extension PlaylistViewController {
    private func bindActions() {
        playlistView.thumbnailImageView.isUserInteractionEnabled = true
        playlistView.thumbnailImageView.tapPublisher().sink { [weak self] _ in
            self?.dismiss(animated: true)
        }.store(in: &subscription)
    }
}

extension PlaylistViewController {
    private func createDatasources(output: PlaylistViewModel.Output) -> RxTableViewSectionedReloadDataSource<PlayListSectionModel> {
        let datasource = RxTableViewSectionedReloadDataSource<PlayListSectionModel>(configureCell: { [weak self] (_ , tableView, indexPath, model) -> UITableViewCell in
            guard let self else { return UITableViewCell() }
            guard let cell = tableView.dequeueReusableCell(withIdentifier:  PlaylistTableViewCell.identifier, for: IndexPath(row: indexPath.row, section: 0)) as? PlaylistTableViewCell
            else { return UITableViewCell() }
            
            cell.delegate = self
            cell.selectionStyle = .none
            
            let index = indexPath.row
            let isEditing = output.editState.value
            let isPlaying = model.isPlaying
            let isAnimating = self.playState.state == .playing
            
            cell.setContent(song: model.item, index: index, isEditing: isEditing, isPlaying: isPlaying, isAnimating: isAnimating)
            return cell
            
        }, canEditRowAtIndexPath: { (_, _) -> Bool in
            return true
        }, canMoveRowAtIndexPath: { (_, _) -> Bool in
            return true
        })
        return datasource
    }
}
    
