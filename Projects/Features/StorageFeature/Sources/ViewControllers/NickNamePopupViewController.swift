//
//  NickNamePopupViewController.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/03/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import PanModal
import RxRelay
import RxSwift
import UIKit
import Utility

public final class NickNamePopupViewController: UIViewController, ViewControllerFromStoryBoard {
    @IBOutlet weak var tableView: UITableView!

    var completion: ((String) -> Void)?
    var dataSource: BehaviorRelay<[NickNameInfo]> = BehaviorRelay(value: [
        NickNameInfo(description: PublicNameOption.public.rawValue, check: false),
        NickNameInfo(description: PublicNameOption.private.rawValue, check: false),
        NickNameInfo(description: PublicNameOption.nonSigned.rawValue, check: false)
    ])
    var disposeBag = DisposeBag()

    override public func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    public static func viewController(
        current: String,
        completion: ((String) -> Void)? = nil
    ) -> NickNamePopupViewController {
        let viewController = NickNamePopupViewController.viewController(
            storyBoardName: "Storage",
            bundle: Bundle.module
        )
        viewController.completion = completion

        var newModel = viewController.dataSource.value
        if let index = viewController.dataSource.value.firstIndex(where: { $0.description == current }) {
            newModel[index].check = true
        }
        viewController.dataSource.accept(newModel)

        return viewController
    }
}

extension NickNamePopupViewController {
    private func configureUI() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        dataSource
            .bind(to: tableView.rx.items) { tableView, index, model -> UITableViewCell in
                let indexPath: IndexPath = IndexPath(row: index, section: 0)

                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "NickNameInfoTableViewCell",
                    for: indexPath
                ) as? NickNameInfoTableViewCell else {
                    return UITableViewCell()
                }

                cell.update(model: model)
                return cell
            }
            .disposed(by: disposeBag)

        configureEvent()
    }

    private func configureEvent() {
        tableView.rx.itemSelected
            .withLatestFrom(dataSource) { ($0, $1) }
            .map { indexPath, models in
                var nextModels: [NickNameInfo] = models

                guard let index = models.firstIndex(where: { $0.check }) else {
                    nextModels[indexPath.row].check = true
                    return nextModels
                }
                nextModels[index].check = false
                nextModels[indexPath.row].check = true
                return nextModels
            }
            .do(onNext: { [weak self] model in
                guard let index = model.firstIndex(where: { $0.check }) else { return }
                self?.completion?(model[index].description)
                self?.dismiss(animated: true)
            })
            .bind(to: dataSource)
            .disposed(by: disposeBag)
    }
}

public struct NickNameInfo {
    var description: String
    var check: Bool
}

extension NickNamePopupViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
}

extension NickNamePopupViewController: PanModalPresentable {
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    public var panModalBackgroundColor: UIColor {
        return colorFromRGB(0x000000, alpha: 0.4)
    }

    public var panScrollable: UIScrollView? {
        return nil
    }

    public var longFormHeight: PanModalHeight {
        return PanModalHeight.contentHeight(228)
    }

    public var cornerRadius: CGFloat {
        return 24.0
    }

    public var allowsExtendedPanScrolling: Bool {
        return true
    }

    public var showDragIndicator: Bool {
        return false
    }
}
