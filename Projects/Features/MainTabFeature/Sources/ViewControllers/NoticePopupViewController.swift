//
//  NoticePopupViewController.swift
//  DesignSystem
//
//  Created by KTH on 2023/01/29.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import BaseFeature
import DesignSystem
import LogManager
import NoticeDomainInterface
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit
import Utility

@MainActor
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
    private var viewModel: NoticePopupViewModel!
    private lazy var input = NoticePopupViewModel.Input()
    private lazy var output = viewModel.transform(from: input)
    private let disposeBag = DisposeBag()

    deinit {
        DEBUG_LOG("\(Self.self) Deinit")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        outputBind()
        inputBind()
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LogManager.analytics(CommonAnalyticsLog.viewPage(pageName: .noticePopup))
    }

    public static func viewController(
        viewModel: NoticePopupViewModel
    ) -> NoticePopupViewController {
        let viewController = NoticePopupViewController.viewController(storyBoardName: "Main", bundle: Bundle.module)
        viewController.viewModel = viewModel
        return viewController
    }

    @IBAction func ignoreButtonAction(_ sender: Any) {
        let savedIgoredNoticeIds: [Int] = Utility.PreferenceManager.shared.ignoredPopupIDs ?? []
        let currentNoticeIds: [Int] = output.originDataSource.value.map { $0.id }

        if savedIgoredNoticeIds.isEmpty {
            Utility.PreferenceManager.shared.ignoredPopupIDs = currentNoticeIds
        } else {
            Utility.PreferenceManager.shared.ignoredPopupIDs = savedIgoredNoticeIds + currentNoticeIds
        }
        dismiss(animated: true)
    }

    @IBAction func confirmButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
}

private extension NoticePopupViewController {
    func inputBind() {
        input.fetchFilteredNotice.onNext(())

        collectionView.rx.itemSelected
            .bind(to: input.didTapPopup)
            .disposed(by: disposeBag)
    }

    func outputBind() {
        output.thumbnailDataSource
            .filter { !$0.isEmpty }
            .do(onNext: { [pageCountLabel, pageCountView] model in
                pageCountLabel?.text = "1/\(model.count)"
                pageCountView?.isHidden = model.count <= 1
            })
            .bind(to: collectionView.rx.items) { collectionView, row, model -> UICollectionViewCell in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "NoticeCollectionViewCell",
                    for: IndexPath(row: row, section: 0)
                ) as? NoticeCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.update(model: model)
                return cell
            }
            .disposed(by: disposeBag)

        output.dismissAndCallDelegate
            .bind(with: self) { owner, entity in
                let log = NoticePopupAnalyticsLog.clickNoticeItem(id: "\(entity.id)", location: "notice_popup")
                LogManager.analytics(log)

                owner.dismiss(animated: true) {
                    owner.delegate?.noticeTapped(model: entity)
                }
            }
            .disposed(by: disposeBag)
    }

    func configureUI() {
        self.view.backgroundColor = .white

        let ignoreButtonAttributedString = NSMutableAttributedString.init(string: "다시보지 않기")
        ignoreButtonAttributedString.addAttributes(
            [
                .font: DesignSystemFontFamily.Pretendard.medium.font(size: 18),
                .foregroundColor: DesignSystemAsset.BlueGrayColor.gray25.color,
                .kern: -0.5
            ],
            range: NSRange(
                location: 0,
                length: ignoreButtonAttributedString.string.count
            )
        )
        ignoreButton.backgroundColor = DesignSystemAsset.BlueGrayColor.gray400.color
        ignoreButton.layer.cornerRadius = 12
        ignoreButton.setAttributedTitle(ignoreButtonAttributedString, for: .normal)

        let confirmButtonAttributedString = NSMutableAttributedString.init(string: "닫기")
        confirmButtonAttributedString.addAttributes(
            [
                .font: DesignSystemFontFamily.Pretendard.medium.font(size: 18),
                .foregroundColor: DesignSystemAsset.BlueGrayColor.gray25.color,
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
        pageCountView.backgroundColor = DesignSystemAsset.BlueGrayColor.gray900.color.withAlphaComponent(0.2)
        pageCountView.clipsToBounds = true
        pageCountView.isHidden = true

        pageCountLabel.textColor = DesignSystemAsset.BlueGrayColor.gray25.color
        pageCountLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)

        collectionView.register(
            UINib(nibName: "NoticeCollectionViewCell", bundle: BaseFeatureResources.bundle),
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
        pageCountLabel.text = "\(i + 1)/\(output.thumbnailDataSource.value.count)"
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
