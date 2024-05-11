//
//  AfterSearchContentViewController.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/01/11.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import BaseFeature
import DesignSystem
import RxCocoa
import RxDataSources
import RxSwift
import UIKit
import Utility

public final class AfterSearchContentViewController: BaseViewController, ViewControllerFromStoryBoard {
    @IBOutlet weak var tableView: UITableView!

    var viewModel: AfterSearchContentViewModel!
    lazy var input = AfterSearchContentViewModel.Input()
    lazy var output = viewModel.transform(from: input)
    var disposeBag = DisposeBag()

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindRx()
        bindRxEvent()
        requestFromParent()
    }

    public static func viewController(viewModel: AfterSearchContentViewModel) -> AfterSearchContentViewController {
        let viewController = AfterSearchContentViewController.viewController(
            storyBoardName: "Search",
            bundle: Bundle.module
        )
        viewController.viewModel = viewModel
        return viewController
    }
}

extension AfterSearchContentViewController {
    private func bindRx() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        // xib로 만든 UI를 컬렉션 뷰에서 사용하기 위해서는 등록이 필요
        // 다른 모듈 시 번들 변경 Bundle.module 사용 X
        tableView.register(
            UINib(nibName: "SongListCell", bundle: BaseFeatureResources.bundle),
            forCellReuseIdentifier: "SongListCell"
        )

        output.dataSource
            .do(onNext: { [weak self] model in
                guard let self = self else { return }
                self.tableView.isHidden = false // 검색 완료 시 보여줌

                let warningView = WarningView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: APP_HEIGHT() / 2))
                warningView.text = "검색결과가 없습니다."

                if self.viewModel.sectionType == .all {
                    let allSectionisEmpty: Bool = self.output.dataSource.value.map { $0.items }.flatMap { $0 }.isEmpty
                    self.tableView.tableHeaderView = allSectionisEmpty ? warningView : nil

                } else {
                    let isEmpty = model.first?.items.isEmpty ?? false
                    self.tableView.tableHeaderView = isEmpty ? warningView : nil
                }
            })
            .bind(to: tableView.rx.items(dataSource: createDatasource()))
            .disposed(by: disposeBag)
    }

    private func bindRxEvent() {
        tableView.rx.itemSelected
            .bind(to: input.indexPath)
            .disposed(by: disposeBag)

        Utility.PreferenceManager.$startPage
            .skip(1)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self, let parent = self.parent?.parent as? AfterSearchViewController else {
                    return
                }
                self.input.deSelectedAllSongs.accept(())
                //   parent.output.songEntityOfSelectedSongs.accept([])
            }).disposed(by: disposeBag)
    }

    func requestFromParent() {
        guard let parent = self.parent?.parent as? AfterSearchViewController else {
            return
        }
//        let entities = parent.output.songEntityOfSelectedSongs.value
//        let models = output.dataSource.value
//
//        let indexPaths = entities.map { entity -> IndexPath? in
//            var indexPath: IndexPath?
//
//            models.enumerated().forEach { section, model in
//                if let row = model.items.firstIndex(where: { $0 == entity }) {
//                    indexPath = IndexPath(row: row, section: section)
//                }
//            }
//            return indexPath
//        }.compactMap { $0 }

//        input.mandatoryLoadIndexPath.accept(indexPaths)
    }

    private func configureUI() {
        self.tableView.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 56))
        self.tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)
        self.view.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
    }
}

extension AfterSearchContentViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let songlistHeader = EntireSectionHeader()

        if viewModel.sectionType != .all {
            return nil
        }

        let allSectionisEmpty: Bool = self.output.dataSource.value.map { $0.items }.flatMap { $0 }.isEmpty
        if allSectionisEmpty {
            return nil
        }
        songlistHeader.update(self.output.dataSource.value[section].model)
        songlistHeader.delegate = self
        return songlistHeader
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if viewModel.sectionType != .all {
            return 0
        }

        let allSectionisEmpty: Bool = self.output.dataSource.value.map { $0.items }.flatMap { $0 }.isEmpty
        if allSectionisEmpty {
            return 0
        }
        return 44
    }
}

extension AfterSearchContentViewController {
    func createDatasource() -> RxTableViewSectionedReloadDataSource<SearchSectionModel> {
        let datasource = RxTableViewSectionedReloadDataSource<SearchSectionModel>(
            configureCell: { _, tableView, indexPath, model -> UITableViewCell in
                guard let cell = tableView
                    .dequeueReusableCell(withIdentifier: "SongListCell", for: indexPath) as? SongListCell else {
                    return UITableViewCell()
                }
                cell.update(model)
                return cell
            },
            titleForHeaderInSection: { _, _ -> String? in
                return nil
            }
        )
        return datasource
    }
}

extension AfterSearchContentViewController: EntireSectionHeaderDelegate {
    func switchTapEvent(_ type: TabPosition) {
        guard let tabMan = parent?.parent as? AfterSearchViewController else {
            return
        }
        tabMan.scrollToPage(.at(index: type.rawValue), animated: true)
    }
}

extension AfterSearchContentViewController {
    func scrollToTop() {
        let itemIsEmpty: Bool = output.dataSource.value.first?.items.isEmpty ?? true
        guard !itemIsEmpty else { return }
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}
