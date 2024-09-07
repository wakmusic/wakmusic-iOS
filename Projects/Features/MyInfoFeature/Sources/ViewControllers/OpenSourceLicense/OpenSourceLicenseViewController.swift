//
//  OpenSourceLicenseViewController.swift
//  CommonFeature
//
//  Created by KTH on 2023/05/17.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DesignSystem
import RxCocoa
import RxSwift
import SafariServices
import UIKit
import Utility

public class OpenSourceLicenseViewController: UIViewController, ViewControllerFromStoryBoard {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleStringLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    var viewModel: OpenSourceLicenseViewModel!
    var disposeBag: DisposeBag = DisposeBag()
    deinit { DEBUG_LOG("❌ \(Self.self) Deinit") }

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        inputBind()
        outputBind()
        bindBtn()
    }

    public static func viewController(
        viewModel: OpenSourceLicenseViewModel
    ) -> OpenSourceLicenseViewController {
        let viewController = OpenSourceLicenseViewController.viewController(
            storyBoardName: "OpenSourceAndServiceInfo",
            bundle: Bundle.module
        )
        viewController.viewModel = viewModel
        return viewController
    }
}

extension OpenSourceLicenseViewController {
    private func inputBind() {
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .withUnretained(self)
            .withLatestFrom(viewModel.output.dataSource) { ($0.0, $0.1, $1) }
            .subscribe(onNext: { owner, indexPath, dataSource in
                owner.tableView.deselectRow(at: indexPath, animated: true)
                let model = dataSource[indexPath.row]
                guard let URL = URL(string: model.link) else { return }
                let safari = SFSafariViewController(url: URL)
                owner.present(safari, animated: true)
            }).disposed(by: disposeBag)
    }

    private func outputBind() {
        viewModel.output
            .dataSource
            .bind(to: tableView.rx.items) { tableView, index, model -> UITableViewCell in
                switch model.type {
                case .library:
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: "OpenSourceLibraryCell",
                        for: IndexPath(row: index, section: 0)
                    ) as? OpenSourceLibraryCell else {
                        return UITableViewCell()
                    }
                    cell.update(model: model)
                    return cell
                case .license:
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: "OpenSourceLicenseCell",
                        for: IndexPath(row: index, section: 0)
                    ) as? OpenSourceLicenseCell else {
                        return UITableViewCell()
                    }
                    cell.update(model: model)
                    return cell
                }
            }.disposed(by: disposeBag)
    }

    private func bindBtn() {
        backButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }
}

extension OpenSourceLicenseViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = viewModel.output.dataSource.value[indexPath.row]
        switch model.type {
        case .library:
            return OpenSourceLibraryCell.getCellHeight(model: model)
        case .license:
            return OpenSourceLicenseCell.getCellHeight(model: model)
        }
    }
}

extension OpenSourceLicenseViewController {
    private func configureUI() {
        backButton.setImage(DesignSystemAsset.Navigation.back.image, for: .normal)
        view.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray100.color
        titleStringLabel.text = "오픈소스 라이선스"
        titleStringLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        titleStringLabel.textColor = DesignSystemAsset.BlueGrayColor.blueGray900.color
        titleStringLabel.setTextWithAttributes(kernValue: -0.5)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 56))
        tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)
    }
}
