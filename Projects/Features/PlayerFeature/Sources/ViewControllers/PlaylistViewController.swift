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
    var tappedRemoveSongs = PublishSubject<Void>()
    
    private var containSongsComponent: ContainSongsComponent!
    
    public var songCartView: CommonFeature.SongCartView!
    public var bottomSheetView: CommonFeature.BottomSheetView!
    
    init(viewModel: PlaylistViewModel, containSongsComponent: ContainSongsComponent) {
        self.viewModel = viewModel
        self.containSongsComponent = containSongsComponent
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("playlistVC deinit")
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
}

extension PlaylistViewController {
    private func createDatasources(output: PlaylistViewModel.Output) -> RxTableViewSectionedReloadDataSource<PlayListSectionModel> {
        let datasource = RxTableViewSectionedReloadDataSource<PlayListSectionModel>(configureCell: { [weak self] (_ , tableView, indexPath, model) -> UITableViewCell in
            guard let self else { return UITableViewCell() }
            guard let cell = tableView.dequeueReusableCell(withIdentifier:  PlaylistTableViewCell.identifier, for: IndexPath(row: indexPath.row, section: 0)) as? PlaylistTableViewCell
            else { return UITableViewCell() }
            
            cell.delegate = self
            cell.setContent(song: model, output.editState.value, index: indexPath.row)
            cell.selectionStyle = .none
            cell.isPlaying = indexPath.row == self.playState.playList.currentPlayIndex
            cell.isAnimating = self.playState.state == .playing
            
            return cell
            
        }, canEditRowAtIndexPath: { (_, _) -> Bool in
            return true
        }, canMoveRowAtIndexPath: { (_, _) -> Bool in
            return true
        })
        return datasource
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
            playlistTableviewCellDidTapEvent: tappedCellIndex.asObservable(),
            selectAllSongsButtonDidTapEvent: isSelectedAllSongs.asObservable(),
            removeSongsButtonDidTapEvent: tappedRemoveSongs.asObservable()
        )
        let output = self.viewModel.transform(from: input)
        
        bindRx(output: output)
        bindThumbnail(output: output)
        bindCurrentPlayTime(output: output)
        bindRepeatMode(output: output)
        bindShuffleMode(output: output)
        bindPlayButtonImages(output: output)
        bindwaveStreamAnimationView(output: output)
        
        output.willClosePlaylist.sink { [weak self] _ in
            self?.dismiss(animated: true)
        }.store(in: &subscription)
        
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
    }
    
    private func bindRx(output: PlaylistViewModel.Output) {
        output.dataSource
            .bind(to: playlistView.playlistTableView.rx.items(dataSource: createDatasources(output: output)))
            .disposed(by: disposeBag)
        
        playlistView.playlistTableView.rx.itemSelected
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .filter { _ in output.editState.value == false }
            .subscribe(onNext: { (indexPath, dataSource) in
                let song: SongEntity = dataSource[indexPath.section].items[indexPath.row]
                PlayState.shared.loadAndAppendSongsToPlaylist([song])
            })
            .disposed(by: disposeBag)
    }
    
    private func bindThumbnail(output: PlaylistViewModel.Output) {
        output.thumbnailImageURL.sink { [weak self] thumbnailImageURL in
            self?.playlistView.thumbnailImageView.kf.setImage(
                with: URL(string: thumbnailImageURL),
                placeholder: DesignSystemAsset.Logo.placeHolderSmall.image,
                options: [.transition(.fade(0.2))]
            )
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
                let index = self.playState.playList.currentPlayIndex
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

}

extension PlaylistViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none // 편집모드 시 왼쪽 버튼을 숨기려면 .none을 리턴합니다.
    }
    
    public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false // 편집모드 시 셀의 들여쓰기를 없애려면 false를 리턴합니다.
    }
    
    public func tableView(_ tableView: UITableView, dragIndicatorViewForRowAt indexPath: IndexPath) -> UIView? {
        // 편집모드 시 나타나는 오른쪽 Drag Indicator를 변경합니다.
        let dragIndicatorView = UIImageView(image: DesignSystemAsset.Player.playLarge.image)
        dragIndicatorView.frame = .init(x: 0, y: 0, width: 32, height: 32)
        return dragIndicatorView
    }
    
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true // 모든 Cell 을 이동 가능하게 설정합니다.
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // 이동할 데이터를 가져와서 새로운 위치에 삽입합니다.
        playState.playList.reorderPlaylist(from: sourceIndexPath.row, to: destinationIndexPath.row)
        HapticManager.shared.impact(style: .light)
    }
    
    public func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        // 첫 번째 섹션에서만 이동 가능하게 설정합니다.
        if proposedDestinationIndexPath.section != 0 {
            return sourceIndexPath
        }
        return proposedDestinationIndexPath
    }
    
}

extension PlaylistViewController: PlaylistTableViewCellDelegate {
    func superButtonTapped(index: Int) {
        tappedCellIndex.onNext(index)
    }
    
    
}
    
