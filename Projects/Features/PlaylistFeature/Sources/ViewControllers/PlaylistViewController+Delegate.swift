import BaseFeature
import DesignSystem
import Localization
import UIKit
import Utility

extension PlaylistViewController: SongCartViewDelegate {
    public func buttonTapped(type: SongCartSelectType) {
        switch type {
        case let .allSelect(flag):
            self.isSelectedAllSongs.onNext(flag)
        case .addSong:
            let songs: [String] = Array(output.selectedSongIds.value)
            guard let viewController = containSongsFactory.makeView(songs: songs) as? ContainSongsViewController else {
                return
            }

            let count = songs.count

            if PreferenceManager.userInfo == nil {
                let textPopvc = TextPopupViewController.viewController(
                    text: LocalizationStrings.needLoginWarning,
                    cancelButtonIsHidden: false,
                    completion: { [weak self] in
                        guard let self else { return }
                        let vc = self.signInFactory.makeView()
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true) {
                            self.tappedAddPlaylist.onNext(())
                        }
                    }
                )
                self.showBottomSheet(content: textPopvc)
                return
            }
            viewController.modalPresentationStyle = .overFullScreen

            self.present(viewController, animated: true) {
                self.tappedAddPlaylist.onNext(())
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
            self.showBottomSheet(content: popup)
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

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        72
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let playbuttonGroupView = PlayButtonGroupView()
        playbuttonGroupView.delegate = self
        return playbuttonGroupView
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

    public func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true // 모든 Cell 을 이동 가능하게 설정합니다.
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

extension PlaylistViewController: PlayButtonGroupViewDelegate {
    public func play(_ event: PlayEvent) {
        switch event {
        case .allPlay:
            let songIDs = output.playlists.value
                .map(\.id)
                .prefix(50)
            WakmusicYoutubePlayer(ids: Array(songIDs)).play()

        case .shufflePlay:
            let songIDs = output.playlists.value
                .map(\.id)
                .shuffled()
                .prefix(50)
            WakmusicYoutubePlayer(ids: Array(songIDs)).play()
        }
    }
}

extension PlaylistViewController: PlaylistTableViewCellDelegate {
    func playButtonDidTap(key: String) {
        WakmusicYoutubePlayer(id: key).play()
    }

    func superButtonTapped(index: Int) {
        tappedCellIndex.onNext(index)
    }
}
