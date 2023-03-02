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

public class PlaylistViewController: UIViewController {
    var viewModel: PlaylistViewModel!
    var playlistView: PlaylistView!
    var playState = PlayState.shared
    var subscription = Set<AnyCancellable>()
    
    init(viewModel: PlaylistViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
        let songs = playState.playList.list
        let movedData = songs[sourceIndexPath.row]
        playState.playList.remove(at: sourceIndexPath.row)
        playState.playList.insert(movedData, at: destinationIndexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        // 첫 번째 섹션에서만 이동 가능하게 설정합니다.
        if proposedDestinationIndexPath.section != 0 {
            return sourceIndexPath
        }
        return proposedDestinationIndexPath
    }
    
}
    
