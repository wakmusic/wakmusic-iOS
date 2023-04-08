//
//  NoticeViewController.swift
//  StorageFeature
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import RxSwift
import RxCocoa
import DesignSystem

public class NoticeViewController: UIViewController, ViewControllerFromStoryBoard {
    
    @IBOutlet weak var titleStringLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    var viewModel: NoticeViewModel!
    var noticeDetailComponent: NoticeDetailComponent!
    var disposeBag = DisposeBag()

    public override func viewDidLoad() {
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
            .bind(to: tableView.rx.items) { (tableView, index, model) -> UITableViewCell in
                let indexPath: IndexPath = IndexPath(row: index, section: 0)
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeListCell", for: indexPath) as? NoticeListCell else{
                    return UITableViewCell()
                }
                cell.update(model: model)
                return cell
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .withLatestFrom(viewModel.output.dataSource) { ($0, $1) }
            .subscribe(onNext: { [weak self] (indexPath, model) in
                guard let self = self else { return }
                self.tableView.deselectRow(at: indexPath, animated: true)
                let viewController = self.noticeDetailComponent.makeView(model: model[indexPath.row])
                viewController.modalPresentationStyle = .overFullScreen
                self.present(viewController, animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func configureUI() {
        self.view.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
        backButton.setImage(DesignSystemAsset.Navigation.back.image, for: .normal)
    }
}

extension NoticeViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
