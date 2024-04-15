//
//  FavoriteViewController.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/27.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import BaseDomainInterface
import BaseFeature
import DesignSystem
import NVActivityIndicatorView
import RxDataSources
import RxRelay
import RxSwift
import SongsDomainInterface
import UIKit
import UserDomainInterface
import Utility

public typealias FavoriteSectionModel = SectionModel<Int, FavoriteSongEntity>

public final class FavoriteViewController: BaseViewController, ViewControllerFromStoryBoard, SongCartViewType {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!

    private var refreshControl = UIRefreshControl()
    var viewModel: FavoriteViewModel!
    var containSongsComponent: ContainSongsComponent!

    lazy var input = FavoriteViewModel.Input()
    lazy var output = viewModel.transform(from: input)
    var disposeBag = DisposeBag()

    public var songCartView: SongCartView!
    public var bottomSheetView: BottomSheetView!

    let playState = PlayState.shared

    override public func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        inputBindRx()
        outputBindRx()
    }

    public static func viewController(
        viewModel: FavoriteViewModel,
        containSongsComponent: ContainSongsComponent
    ) -> FavoriteViewController {
        let viewController = FavoriteViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        viewController.viewModel = viewModel
        viewController.containSongsComponent = containSongsComponent
        return viewController
    }
}

extension FavoriteViewController {
    private func inputBindRx() {
        refreshControl.rx
            .controlEvent(.valueChanged)
            .bind(to: input.likeListLoad)
            .disposed(by: disposeBag)

        tableView.rx.itemMoved
            .bind(to: input.itemMoved)
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .withLatestFrom(output.state) { ($0.0, $0.1, $1) }
            .filter { $0.2.isEditing == false }
            .subscribe(onNext: { indexPath, dataSource, _ in
                let song: SongEntity = dataSource[indexPath.section].items[indexPath.row].song
                PlayState.shared.loadAndAppendSongsToPlaylist([song])
            })
            .disposed(by: disposeBag)
    }

    private func outputBindRx() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        output.dataSource
            .do(onNext: { [weak self] model in
                guard let self = self else {
                    return
                }
                self.refreshControl.endRefreshing()
                self.activityIndicator.stopAnimating()

                let warningView = WarningView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: APP_HEIGHT() / 3))
                warningView.text = "좋아요 한 곡이 없습니다."

                let items = model.first?.items ?? []
                self.tableView.tableHeaderView = items.isEmpty ? warningView : nil
            })
            .bind(to: tableView.rx.items(dataSource: createDatasources()))
            .disposed(by: disposeBag)

        output.state
            .skip(1)
            .subscribe(onNext: { [weak self] state in
                guard let self = self else {
                    return
                }
                if state.isEditing == false && state.force == false { // 정상적인 편집 완료 이벤트
                    self.input.runEditing.onNext(())
                }
                guard let parent = self.parent?.parent as? AfterLoginViewController else {
                    return
                }
                // 탭맨 쪽 편집 변경
                let isEdit: Bool = state.isEditing
                parent.output.state.accept(EditState(isEditing: isEdit, force: true))
                self.tableView.refreshControl = isEdit ? nil : self.refreshControl
                self.tableView.setEditing(isEdit, animated: true)
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)

        output.indexPathOfSelectedLikeLists
            .skip(1)
            .debug("indexPathOfSelectedLikeLists")
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .subscribe(onNext: { [weak self] songs, dataSource in
                guard let self = self else { return }
                let items = dataSource.first?.items ?? []

                switch songs.isEmpty {
                case true:
                    self.hideSongCart()
                case false:
                    self.showSongCart(
                        in: UIApplication.shared.windows.first?.rootViewController?.view ?? UIView(),
                        type: .likeSong,
                        selectedSongCount: songs.count,
                        totalSongCount: items.count,
                        useBottomSpace: true
                    )
                    self.songCartView?.delegate = self
                }
            }).disposed(by: disposeBag)

        output.willAddSongList
            .skip(1)
            .debug("willAddSongList")
            .subscribe(onNext: { [weak self] songs in
                guard let `self` = self else { return }
                let viewController = self.containSongsComponent.makeView(songs: songs)
                viewController.modalPresentationStyle = .overFullScreen
                self.present(viewController, animated: true) {
                    self.input.allLikeListSelected.onNext(false)
                }
            }).disposed(by: disposeBag)

        output.willAddPlayList
            .skip(1)
            .debug("willAddPlayList")
            .subscribe(onNext: { [weak self] songs in
                guard let self = self else { return }
                self.playState.appendSongsToPlaylist(songs)
                self.input.allLikeListSelected.onNext(false)
                self.output.state.accept(EditState(isEditing: false, force: true))
                self.showToast(
                    text: "\(songs.count)곡이 재생목록에 추가되었습니다. 중복 곡은 제외됩니다.",
                    font: DesignSystemFontFamily.Pretendard.light.font(size: 14)
                )
            }).disposed(by: disposeBag)

        output.showToast
            .subscribe(onNext: { [weak self] (result: BaseEntity) in
                guard let self = self else { return }

                self.showToast(
                    text: result.description,
                    font: DesignSystemFontFamily.Pretendard.light.font(size: 14)
                )
            })
            .disposed(by: disposeBag)

        output.onLogout.bind(with: self) { owner, error in
            NotificationCenter.default.post(name: .movedTab, object: 4)

            owner.showToast(
                text: error.localizedDescription,
                font: DesignSystemFontFamily.Pretendard.light.font(size: 14)
            )
        }
        .disposed(by: disposeBag)
    }

    private func createDatasources() -> RxTableViewSectionedReloadDataSource<FavoriteSectionModel> {
        let datasource = RxTableViewSectionedReloadDataSource<FavoriteSectionModel>(
            configureCell: { [weak self] _, tableView, indexPath, model -> UITableViewCell in
                guard let self = self,
                      let cell = tableView.dequeueReusableCell(
                          withIdentifier: "FavoriteTableViewCell",
                          for: IndexPath(row: indexPath.row, section: 0)
                      ) as? FavoriteTableViewCell
                else { return UITableViewCell() }

                cell.update(
                    model: model,
                    isEditing: self.output.state.value.isEditing,
                    indexPath: indexPath
                )
                cell.delegate = self
                return cell

            },
            canEditRowAtIndexPath: { _, _ -> Bool in
                return true
            },
            canMoveRowAtIndexPath: { _, _ -> Bool in
                return true
            }
        )
        return datasource
    }

    private func configureUI() {
        self.tableView.refreshControl = self.refreshControl
        self.view.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
        self.tableView.backgroundColor = .clear
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 56))
        self.tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)
        self.activityIndicator.type = .circleStrokeSpin
        self.activityIndicator.color = DesignSystemAsset.PrimaryColor.point.color
        self.activityIndicator.startAnimating()
    }
}

extension FavoriteViewController: SongCartViewDelegate {
    public func buttonTapped(type: SongCartSelectType) {
        switch type {
        case let .allSelect(flag):
            input.allLikeListSelected.onNext(flag)
        case .addSong:
            input.addSongs.onNext(())
            self.output.state.accept(EditState(isEditing: false, force: true))
            self.hideSongCart()
        case .addPlayList:
            input.addPlayList.onNext(())
            self.hideSongCart()
        case .remove:
            let count: Int = output.indexPathOfSelectedLikeLists.value.count
            let popup = TextPopupViewController.viewController(
                text: "선택한 좋아요 리스트 \(count)곡이 삭제됩니다.",
                cancelButtonIsHidden: false,
                completion: { [weak self] () in
                    guard let `self` = self else { return }
                    self.input.deleteLikeList.onNext(())
                    self.hideSongCart()
                }
            )
            self.showPanModal(content: popup)
        default: return
        }
    }
}

extension FavoriteViewController: FavoriteTableViewCellDelegate {
    public func buttonTapped(type: FavoriteTableViewCellDelegateConstant) {
        switch type {
        case let .listTapped(indexPath):
            input.itemSelected.onNext(indexPath)
        case let .playTapped(song):
            playState.loadAndAppendSongsToPlaylist([song])
        }
    }
}

extension FavoriteViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell
        .EditingStyle {
        return .none // 편집모드 시 왼쪽 버튼을 숨기려면 .none을 리턴합니다.
    }

    public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false // 편집모드 시 셀의 들여쓰기를 없애려면 false를 리턴합니다.
    }
}

extension FavoriteViewController {
    func scrollToTop() {
        let itemIsEmpty: Bool = output.dataSource.value.first?.items.isEmpty ?? true
        guard !itemIsEmpty else { return }
        tableView.setContentOffset(.zero, animated: true)
    }
}
