//
//  SearchContentViewController.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/01/05.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import BaseFeature
import DesignSystem
import NeedleFoundation
import NVActivityIndicatorView
import PlayListDomainInterface
import PlaylistFeatureInterface
import RxCocoa
import RxSwift
import UIKit
import Utility

protocol BeforeSearchContentViewDelegate: AnyObject {
    func itemSelected(_ keyword: String)
}

public final class BeforeSearchContentViewController: BaseViewController, ViewControllerFromStoryBoard {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicator: NVActivityIndicatorView!

    weak var delegate: BeforeSearchContentViewDelegate?

    var playlistDetailFactory: PlaylistDetailFactory!
    var viewModel: BeforeSearchContentViewModel!
    let disposeBag = DisposeBag()

    private lazy var input = viewModel.input
    private lazy var output = viewModel.transform(from: input)

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindTable()
    }

    public static func viewController(
        playlistDetailFactory: PlaylistDetailFactory,
        viewModel: BeforeSearchContentViewModel
    ) -> BeforeSearchContentViewController {
        let viewController = BeforeSearchContentViewController.viewController(
            storyBoardName: "Search",
            bundle: Bundle.module
        )
        viewController.playlistDetailFactory = playlistDetailFactory
        viewController.viewModel = viewModel
        return viewController
    }
}

extension BeforeSearchContentViewController {
    private func configureUI() {
        self.tableView.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
        self.tableView.tableFooterView = UIView(frame: .init(x: 0, y: 0, width: APP_WIDTH(), height: PLAYER_HEIGHT()))
        self.tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: PLAYER_HEIGHT(), right: 0)
        self.indicator.type = .circleStrokeSpin
        self.indicator.color = DesignSystemAsset.PrimaryColor.point.color
        self.indicator.startAnimating()
    }

    private func bindTable() {
        // 헤더 적용을 위한 델리게이트
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        // cell 그리기
        let combine = Observable.combineLatest(
            output.showRecommend,
            Utility.PreferenceManager.$recentRecords,
            output.dataSource
        ) { ($0, $1 ?? [], $2) }
        // 추천 리스트 플래그 와 유저디폴트 기록을 모두 감지

        combine
            .skip(2)
            .map { (showRecommend: Bool, item: [String], _) -> [String] in
                if showRecommend { // 만약 추천리스트면 검색목록 보여지면 안되므로 빈 배열
                    return []
                } else {
                    return item
                }
            }
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.indicator.stopAnimating()
            })
            .bind(to: tableView.rx.items) { (
                tableView: UITableView,
                index: Int,
                element: String
            ) -> RecentRecordTableViewCell in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "RecentRecordTableViewCell",
                    for: IndexPath(row: index, section: 0)
                ) as? RecentRecordTableViewCell else {
                    return RecentRecordTableViewCell()
                }
                cell.backgroundColor = .clear
                cell.recentLabel.text = element
                return cell
            }.disposed(by: disposeBag)

        // 터치 이벤트
        tableView.rx.modelSelected(String.self)
            .subscribe(onNext: { [weak self] keyword in
                guard let self = self else {
                    return
                }
                self.delegate?.itemSelected(keyword)
            }).disposed(by: disposeBag)

        guard let parent = self.parent as? SearchViewController else {
            return
        }

        parent.viewModel.output.isFoucused
            .withLatestFrom(parent.viewModel.input.textString) { ($0, $1) }
            .map { (focus: Bool, str: String) -> Bool in
                return focus == false && str.isWhiteSpace == true
            }
            .bind(to: output.showRecommend)
            .disposed(by: disposeBag)
    }
}

extension BeforeSearchContentViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if output.showRecommend.value {
            return RecommendPlayListView.getViewHeight(model: output.dataSource.value)

        } else if (Utility.PreferenceManager.recentRecords ?? []).isEmpty {
            return (APP_HEIGHT() * 3) / 8

        } else {
            return 68
        }
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let warningView = WarningView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 300))
        warningView.text = "최근 검색 기록이 없습니다."

        let recentRecordHeaderView = RecentRecordHeaderView()

        // 최근 검색어 전체 삭제 버튼 클릭 이벤트 받는 통로
        recentRecordHeaderView.completionHandler = {
            let textPopupViewController = TextPopupViewController.viewController(
                text: "전체 내역을 삭제하시겠습니까?",
                cancelButtonIsHidden: false,
                completion: { // 승인 핸들러
                    Utility.PreferenceManager.recentRecords = nil
                }
            )
            self.showPanModal(content: textPopupViewController)
        }

        let recommendView = RecommendPlayListView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: APP_WIDTH(),
                height: RecommendPlayListView.getViewHeight(model: output.dataSource.value)
            )
        )
        recommendView.dataSource = self.output.dataSource.value
        recommendView.delegate = self

        if output.showRecommend.value {
            return recommendView

        } else if (Utility.PreferenceManager.recentRecords ?? []).isEmpty {
            return warningView

        } else {
            return recentRecordHeaderView
        }
    }
}

extension BeforeSearchContentViewController: RecommendPlayListViewDelegate {
    public func itemSelected(model: RecommendPlayListEntity) {
        lazy var playListDetailVc = playlistDetailFactory.makeView(
            id: model.key,
            isCustom: false
        )
        self.navigationController?.pushViewController(playListDetailVc, animated: true)
    }
}

extension BeforeSearchContentViewController {
    func scrollToTop() {
        tableView.setContentOffset(.zero, animated: true)
    }
}
