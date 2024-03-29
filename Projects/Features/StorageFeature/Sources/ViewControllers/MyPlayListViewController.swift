//
//  MyPlayListViewController.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/27.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import BaseFeature
import CommonFeature
import DesignSystem
import NVActivityIndicatorView
import PanModal
import RxCocoa
import RxDataSources
import RxRelay
import RxSwift
import SongsDomainInterface
import UIKit
import UserDomainInterface
import Utility

public typealias MyPlayListSectionModel = SectionModel<Int, PlayListEntity>

public final class MyPlayListViewController: BaseViewController, ViewControllerFromStoryBoard, SongCartViewType {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!

    private var refreshControl = UIRefreshControl()
    var multiPurposePopComponent: MultiPurposePopComponent!
    var playListDetailComponent: PlayListDetailComponent!
    var viewModel: MyPlayListViewModel!

    lazy var input = MyPlayListViewModel.Input()
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
        viewModel: MyPlayListViewModel,
        multiPurposePopComponent: MultiPurposePopComponent,
        playListDetailComponent: PlayListDetailComponent
    ) -> MyPlayListViewController {
        let viewController = MyPlayListViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        viewController.viewModel = viewModel
        viewController.multiPurposePopComponent = multiPurposePopComponent
        viewController.playListDetailComponent = playListDetailComponent
        return viewController
    }
}

extension MyPlayListViewController {
    private func inputBindRx() {
        refreshControl.rx
            .controlEvent(.valueChanged)
            .bind(to: input.playListLoad)
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .debug()
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .withLatestFrom(output.state) { ($0.0, $0.1, $1) }
            .debug()
            .subscribe(onNext: { [weak self] indexPath, dataSource, state in
                guard let self = self else { return }

                let isEditing: Bool = state.isEditing

                if isEditing { // 편집 중일 때, 동작 안함
                    self.input.itemSelected.onNext(indexPath)

                } else {
                    let id: String = dataSource[indexPath.section].items[indexPath.row].key
                    let vc = self.playListDetailComponent.makeView(id: id, type: .custom)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            })
            .disposed(by: disposeBag)

        tableView.rx.itemMoved
            .debug("itemMoved")
            .bind(to: input.itemMoved)
            .disposed(by: disposeBag)
    }

    private func outputBindRx() {
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

                let header = MyPlayListHeaderView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 140))
                header.delegate = self
                self.tableView.tableHeaderView = isEdit ? nil : header
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)

        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        output.dataSource
            .skip(1)
            .do(onNext: { [weak self] model in
                guard let self = self else {
                    return
                }
                self.refreshControl.endRefreshing()
                self.activityIndicator.stopAnimating()

                let warningView = WarningView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: APP_HEIGHT() / 3))
                warningView.text = "내 리스트가 없습니다."

                let items = model.first?.items ?? []
                self.tableView.tableFooterView = items.isEmpty ? warningView : UIView(frame: CGRect(
                    x: 0,
                    y: 0,
                    width: APP_WIDTH(),
                    height: 56
                ))
            })
            .bind(to: tableView.rx.items(dataSource: createDatasources()))
            .disposed(by: disposeBag)

        output.indexPathOfSelectedPlayLists
            .skip(1)
            .debug("indexPathOfSelectedPlayLists")
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
                        type: .myList,
                        selectedSongCount: songs.count,
                        totalSongCount: items.count,
                        useBottomSpace: true
                    )
                    self.songCartView?.delegate = self
                }
            }).disposed(by: disposeBag)

        output.willAddPlayList
            .skip(1)
            .debug("willAddPlayList")
            .subscribe(onNext: { [weak self] songs in
                guard let self = self else { return }
                if !songs.isEmpty {
                    self.playState.appendSongsToPlaylist(songs)
                }
                self.input.allPlayListSelected.onNext(false)
                self.output.state.accept(EditState(isEditing: false, force: true))
                let message: String = songs.isEmpty ?
                    "리스트에 곡이 없습니다." :
                    "\(songs.count)곡이 재생목록에 추가되었습니다. 중복 곡은 제외됩니다."
                self.showToast(
                    text: message,
                    font: DesignSystemFontFamily.Pretendard.light.font(size: 14)
                )
            }).disposed(by: disposeBag)

        output.showToast
            .subscribe(onNext: { [weak self] result in
                guard let self = self else {
                    return
                }

                if result.status == 401 {
                    LOGOUT()
                }

                self.showToast(
                    text: result.description,
                    font: DesignSystemFontFamily.Pretendard.light.font(size: 14)
                )
            })
            .disposed(by: disposeBag)
    }

    private func createDatasources() -> RxTableViewSectionedReloadDataSource<MyPlayListSectionModel> {
        let datasource = RxTableViewSectionedReloadDataSource<MyPlayListSectionModel>(
            configureCell: { [weak self] _, tableView, indexPath, model -> UITableViewCell in
                guard let self = self else { return UITableViewCell() }

                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "MyPlayListTableViewCell",
                    for: IndexPath(row: indexPath.row, section: 0)
                ) as? MyPlayListTableViewCell
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
        let header = MyPlayListHeaderView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 140))
        header.delegate = self
        self.tableView.tableHeaderView = header
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 56))
        self.tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)
        self.activityIndicator.type = .circleStrokeSpin
        self.activityIndicator.color = DesignSystemAsset.PrimaryColor.point.color
        self.activityIndicator.startAnimating()
    }
}

extension MyPlayListViewController: SongCartViewDelegate {
    public func buttonTapped(type: SongCartSelectType) {
        switch type {
        case let .allSelect(flag):
            input.allPlayListSelected.onNext(flag)

        case .addPlayList:
            input.addPlayList.onNext(())
            self.hideSongCart()

        case .remove:
            let count: Int = output.indexPathOfSelectedPlayLists.value.count
            let popup = TextPopupViewController.viewController(
                text: "선택한 내 리스트 \(count)개가 삭제됩니다.",
                cancelButtonIsHidden: false,
                completion: { [weak self] () in
                    guard let `self` = self else { return }
                    self.input.deletePlayList.onNext(())
                    self.hideSongCart()
                }
            )
            self.showPanModal(content: popup)

        default: return
        }
    }
}

extension MyPlayListViewController: MyPlayListTableViewCellDelegate {
    public func buttonTapped(type: MyPlayListTableViewCellDelegateConstant) {
        switch type {
        case let .listTapped(indexPath):
            input.itemSelected.onNext(indexPath)
        case let .playTapped(indexPath):
            let songs: [SongEntity] = output.dataSource.value[indexPath.section].items[indexPath.row].songlist
            guard !songs.isEmpty else {
                self.showToast(
                    text: "리스트에 곡이 없습니다.",
                    font: DesignSystemFontFamily.Pretendard.light.font(size: 14)
                )
                return
            }
            self.playState.loadAndAppendSongsToPlaylist(songs)
        }
    }
}

extension MyPlayListViewController: UITableViewDelegate {
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

extension MyPlayListViewController: MyPlayListHeaderViewDelegate {
    public func action(_ type: PurposeType) {
        if let parent = self.parent?.parent as? AfterLoginViewController {
            parent.hideEditSheet()
            parent.profileButton.isSelected = false
        }
        let vc = multiPurposePopComponent.makeView(type: type)
        self.showEntryKitModal(content: vc, height: 296)
    }
}

extension MyPlayListViewController {
    func scrollToTop() {
        let itemIsEmpty: Bool = output.dataSource.value.first?.items.isEmpty ?? true
        guard !itemIsEmpty else { return }
        tableView.setContentOffset(.zero, animated: true)
    }
}
