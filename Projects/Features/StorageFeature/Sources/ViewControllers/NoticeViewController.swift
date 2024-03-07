//
//  NoticeViewController.swift
//  StorageFeature
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import CommonFeature
import DesignSystem
import NVActivityIndicatorView
import RxCocoa
import RxSwift
import UIKit
import Utility

public class NoticeViewController: UIViewController, ViewControllerFromStoryBoard {
    @IBOutlet weak var titleStringLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var indicator: NVActivityIndicatorView!

    var viewModel: NoticeViewModel!
    var noticeDetailComponent: NoticeDetailComponent!
    var disposeBag = DisposeBag()

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }

    public static func viewController(
        viewModel: NoticeViewModel,
        noticeDetailComponent: NoticeDetailComponent
    ) -> NoticeViewController {
        let viewController = NoticeViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        viewController.viewModel = viewModel
        viewController.noticeDetailComponent = noticeDetailComponent
        return viewController
    }

    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension NoticeViewController {
    private func bind() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        viewModel.output.dataSource
            .skip(1)
            .do(onNext: { [weak self] model in
                self?.indicator.stopAnimating()
                let space = APP_HEIGHT() - 48 - STATUS_BAR_HEGHIT() - SAFEAREA_BOTTOM_HEIGHT()
                let height = space / 3 * 2
                let warningView = WarningView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: height))
                warningView.text = "공지사항이 없습니다."
                self?.tableView.tableFooterView = model.isEmpty ? warningView : UIView(frame: CGRect(
                    x: 0,
                    y: 0,
                    width: APP_WIDTH(),
                    height: 56
                ))
            })
            .bind(to: tableView.rx.items) { tableView, index, model -> UITableViewCell in
                let indexPath: IndexPath = IndexPath(row: index, section: 0)
                guard let cell = tableView
                    .dequeueReusableCell(withIdentifier: "NoticeListCell", for: indexPath) as? NoticeListCell else {
                    return UITableViewCell()
                }
                cell.update(model: model)
                return cell
            }.disposed(by: disposeBag)

        tableView.rx.itemSelected
            .withLatestFrom(viewModel.output.dataSource) { ($0, $1) }
            .subscribe(onNext: { [weak self] indexPath, model in
                guard let self = self else { return }
                self.tableView.deselectRow(at: indexPath, animated: true)
                let viewController = self.noticeDetailComponent.makeView(model: model[indexPath.row])
                viewController.modalPresentationStyle = .overFullScreen
                self.present(viewController, animated: true)
            }).disposed(by: disposeBag)
    }

    private func configureUI() {
        self.view.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 56))
        self.tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)
        self.backButton.setImage(DesignSystemAsset.Navigation.back.image, for: .normal)
        let attributedString: NSAttributedString = NSAttributedString(
            string: "공지사항",
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.medium.font(size: 16),
                .foregroundColor: DesignSystemAsset.GrayColor.gray900.color,
                .kern: -0.5
            ]
        )
        self.titleStringLabel.attributedText = attributedString
        self.indicator.type = .circleStrokeSpin
        self.indicator.color = DesignSystemAsset.PrimaryColor.point.color
        self.indicator.startAnimating()
    }
}

extension NoticeViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
