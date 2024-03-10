//
//  NoticePopupViewController.swift
//  DesignSystem
//
//  Created by KTH on 2023/01/29.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DesignSystem
import PanModal
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit
import Utility
import NoticeDomainInterface

public protocol NoticePopupViewControllerDelegate: AnyObject {
    func noticeTapped(model: FetchNoticeEntity)
}

public class NoticePopupViewController: UIViewController, ViewControllerFromStoryBoard {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageCountView: UIView!
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var ignoreButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!

    public weak var delegate: NoticePopupViewControllerDelegate?
    var viewModel: NoticePopupViewModel!
    var disposeBag = DisposeBag()

    deinit {
        DEBUG_LOG("\(Self.self) Deinit")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }

    public static func viewController(
        viewModel: NoticePopupViewModel
    ) -> NoticePopupViewController {
        let viewController = NoticePopupViewController.viewController(storyBoardName: "CommonUI", bundle: Bundle.module)
        viewController.viewModel = viewModel
        return viewController
    }

    @IBAction func ignoreButtonAction(_ sender: Any) {
        let savedIgoredNoticeIds: [Int] = Utility.PreferenceManager.ignoredNoticeIDs ?? []
        let currentNoticeIds: [Int] = viewModel.output.ids.value

        if savedIgoredNoticeIds.isEmpty {
            Utility.PreferenceManager.ignoredNoticeIDs = currentNoticeIds
        } else {
            Utility.PreferenceManager.ignoredNoticeIDs = savedIgoredNoticeIds + currentNoticeIds
        }
        dismiss(animated: true)
    }

    @IBAction func confirmButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension NoticePopupViewController {
    private func bind() {
        viewModel.output
            .dataSource
            .do(onNext: { [weak self] model in
                self?.pageCountLabel.text = "1/\(model.count)"
                self?.pageCountView.isHidden = model.count <= 1
            })
            .bind(to: collectionView.rx.items) { collectionView, row, model -> UICollectionViewCell in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "NoticeCollectionViewCell",
                    for: IndexPath(row: row, section: 0)
                ) as? NoticeCollectionViewCell else { return UICollectionViewCell() }
                cell.update(model: model)
                return cell
            }
            .disposed(by: disposeBag)

        collectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                owner.dismiss(animated: true) {
                    owner.delegate?.noticeTapped(model: owner.viewModel.fetchNoticeEntities[indexPath.row])
                }
            }).disposed(by: disposeBag)
    }

    private func configureUI() {
        self.view.backgroundColor = .white

        let ignoreButtonAttributedString = NSMutableAttributedString.init(string: "다시보지 않기")
        ignoreButtonAttributedString.addAttributes(
            [
                .font: DesignSystemFontFamily.Pretendard.medium.font(size: 18),
                .foregroundColor: DesignSystemAsset.GrayColor.gray25.color,
                .kern: -0.5
            ],
            range: NSRange(
                location: 0,
                length: ignoreButtonAttributedString.string.count
            )
        )
        ignoreButton.backgroundColor = DesignSystemAsset.GrayColor.gray400.color
        ignoreButton.layer.cornerRadius = 12
        ignoreButton.setAttributedTitle(ignoreButtonAttributedString, for: .normal)

        let confirmButtonAttributedString = NSMutableAttributedString.init(string: "닫기")
        confirmButtonAttributedString.addAttributes(
            [
                .font: DesignSystemFontFamily.Pretendard.medium.font(size: 18),
                .foregroundColor: DesignSystemAsset.GrayColor.gray25.color,
                .kern: -0.5
            ],
            range: NSRange(
                location: 0,
                length: confirmButtonAttributedString.string.count
            )
        )
        confirmButton.backgroundColor = DesignSystemAsset.PrimaryColor.point.color
        confirmButton.layer.cornerRadius = 12
        confirmButton.setAttributedTitle(confirmButtonAttributedString, for: .normal)

        pageCountView.layer.cornerRadius = 12
        pageCountView.backgroundColor = DesignSystemAsset.GrayColor.gray900.color.withAlphaComponent(0.2)
        pageCountView.clipsToBounds = true
        pageCountView.isHidden = true

        pageCountLabel.textColor = DesignSystemAsset.GrayColor.gray25.color
        pageCountLabel.font = DesignSystemFontFamily.SCoreDream._3Light.font(size: 14)

        collectionView.register(
            UINib(nibName: "NoticeCollectionViewCell", bundle: Bundle.module),
            forCellWithReuseIdentifier: "NoticeCollectionViewCell"
        )
        collectionView.isPagingEnabled = true
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        collectionView.bounces = false
    }
}

extension NoticePopupViewController: UIScrollViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let i = Int(scrollView.contentOffset.x / APP_WIDTH())
        self.pageCountLabel.text = "\(i + 1)/\(viewModel.output.dataSource.value.count)"
    }
}

extension NoticePopupViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: APP_WIDTH(), height: APP_WIDTH())
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
}

extension NoticePopupViewController: PanModalPresentable {
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
        return PanModalHeight.contentHeight(APP_WIDTH() + 20 + 56 + 20)
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
