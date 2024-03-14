//
//  PlaylistViewController+SongCartViewDelegate.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/04/07.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import CommonFeature
import DesignSystem
import UIKit
import Utility

extension PlaylistViewController: SongCartViewDelegate {
    public func buttonTapped(type: SongCartSelectType) {
        switch type {
        case let .allSelect(flag):
            self.isSelectedAllSongs.onNext(flag)
        case .addSong:
            let songs: [String] = self.playState.playList.list.filter { $0.item.isSelected }.map { $0.item.id }
            let viewController = containSongsComponent.makeView(songs: songs)
            viewController.delegate = self
            viewController.modalPresentationStyle = .overFullScreen

            self.present(viewController, animated: true) {
                self.tappedAddPlaylist.onNext(())
                self.hideSongCart()
            }

        case .remove:
            let count: Int = self.viewModel.countOfSelectedSongs
            let popup = TextPopupViewController.viewController(
                text: "선택한 내 리스트 \(count)곡이 삭제됩니다.",
                cancelButtonIsHidden: false,
                completion: { [weak self] () in
                    guard let self else { return }
                    self.tappedRemoveSongs.onNext(())
                    self.hideSongCart()
                }
            )
            self.showPanModal(content: popup)
        default:
            return
        }
    }
}

extension PlaylistViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell
        .EditingStyle {
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

    public func tableView(
        _ tableView: UITableView,
        moveRowAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath
    ) {
        // 이동할 데이터를 가져와서 새로운 위치에 삽입합니다.
        playState.playList.reorderPlaylist(from: sourceIndexPath.row, to: destinationIndexPath.row)
        HapticManager.shared.impact(style: .light)
    }

    public func tableView(
        _ tableView: UITableView,
        targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath,
        toProposedIndexPath proposedDestinationIndexPath: IndexPath
    ) -> IndexPath {
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

extension PlaylistViewController: ContainSongsViewDelegate {
    public func tokenExpired() {
        self.dismiss(animated: true)
    }
}
