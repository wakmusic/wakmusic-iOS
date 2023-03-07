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
import YouTubePlayerKit

public class PlaylistViewController: UIViewController {
    var viewModel: PlaylistViewModel!
    var playlistView: PlaylistView!
    var playState = PlayState.shared
    var subscription = Set<AnyCancellable>()

    init(viewModel: PlaylistViewModel) {
        self.viewModel = viewModel
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
        playlistView.playlistTableView.delegate = self
        playlistView.playlistTableView.dataSource = self
        bindViewModel()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchThumbnailImageView))
        playlistView.thumbnailImageView.isUserInteractionEnabled = true
        playlistView.thumbnailImageView.addGestureRecognizer(tapGesture)
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
            shuffleButtonDidTapEvent: playlistView.shuffleButton.tapPublisher
        )
        let output = self.viewModel.transform(from: input)
        
        bindThumbnail(output: output)
        bindCurrentPlayTime(output: output)
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
            self.playlistView.playlistTableView.visibleCells.forEach { $0.isEditing = isEditing }
            
        }.store(in: &subscription)
        
        output.currentSongIndex.sink { [weak self] currentSongIndex in
            self?.updatePlayingStatus(currentSongIndex: currentSongIndex)
        }.store(in: &subscription)
    }
    
    private func bindThumbnail(output: PlaylistViewModel.Output) {
        output.thumbnailImageURL.sink { [weak self] thumbnailImageURL in
            self?.playlistView.thumbnailImageView.kf.setImage(with: URL(string: thumbnailImageURL))
        }.store(in: &subscription)
    }
    
    private func bindCurrentPlayTime(output: PlaylistViewModel.Output) {
        output.playTimeValue.sink { [weak self] value in
            guard let self else { return }
            self.playlistView.currentPlayTimeView.snp.remakeConstraints {
                let playTimeValue = output.playTimeValue.value
                let totalTimeValue = output.totalTimeValue.value
                let newValue = totalTimeValue == 0 ? 0 : playTimeValue / totalTimeValue
                $0.top.left.bottom.equalToSuperview()
                $0.width.equalTo(self.playlistView.totalPlayTimeView.snp.width).multipliedBy(newValue)
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
        output.playerState.sink { [weak self] state in
            guard let self else { return }
            let indexPath = IndexPath(row: self.playState.playList.currentPlayIndex, section: 0)
            guard let currentPlayingCell = self.playlistView.playlistTableView.cellForRow(at: indexPath) as? PlaylistTableViewCell else { return }
            // 노래를 일시정지하면 애니메이션도 일시정지
            switch state {
            case .playing:
                currentPlayingCell.waveStreamAnimationView.play()
            default:
                currentPlayingCell.waveStreamAnimationView.pause()
            }
        }.store(in: &subscription)
    }
    
    private func updatePlayingStatus(currentSongIndex: Int) {
        // 모든 셀에 대해서 재생상태 업데이트
        let rows = playlistView.playlistTableView.numberOfRows(inSection: 0)
        for row in 0..<rows {
            let indexPath = IndexPath(row: row, section: 0)
            if let cell = playlistView.playlistTableView.cellForRow(at: indexPath) as? PlaylistTableViewCell {
                cell.isPlaying = (row == currentSongIndex)
            }
        }
    }
    
}

private extension PlaylistViewController {
    @objc private func touchThumbnailImageView() {
        self.dismiss(animated: true)
    }
}

extension PlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playState.playList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistTableViewCell.identifier, for: indexPath) as? PlaylistTableViewCell
        else { return UITableViewCell() }
        cell.selectionStyle = .none
        let songs = playState.playList.list
        cell.setContent(song: songs[indexPath.row])
        cell.isPlaying = indexPath.row == 0 ? true : false // 임시로
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if playState.playList.currentPlayIndex != indexPath.row {
            playState.loadInPlaylist(at: indexPath.row) // 현재 재생중인 곡 이외의 Cell을 선택 시 해당 곡이 재생됩니다.
        }
    }
    
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
    
