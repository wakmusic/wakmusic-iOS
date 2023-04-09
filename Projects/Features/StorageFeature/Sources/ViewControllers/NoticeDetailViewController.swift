//
//  NoticeDetailViewController.swift
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
import RxDataSources
import DomainModule
import CommonFeature

typealias NoticeDetailSectionModel = SectionModel<FetchNoticeEntity, String>

public class NoticeDetailViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var titleStringLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
        
    var viewModel: NoticeDetailViewModel!
    var disposeBag = DisposeBag()

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    public static func viewController(
        viewModel: NoticeDetailViewModel
    ) -> NoticeDetailViewController {
        let viewController = NoticeDetailViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        viewController.viewModel = viewModel
        return viewController
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension NoticeDetailViewController {
    private func bind() {
        viewModel.output
            .dataSource
            .bind(to: collectionView.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)
    }
    
    private func createDataSource() -> RxCollectionViewSectionedReloadDataSource<NoticeDetailSectionModel> {
        let dataSource = RxCollectionViewSectionedReloadDataSource<NoticeDetailSectionModel>(configureCell: { (_, collectionView, indexPath, item) -> UICollectionViewCell in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoticeCollectionViewCell", for: indexPath) as? NoticeCollectionViewCell else { return UICollectionViewCell() }
            cell.update(model: item)
            return cell
            
        }, configureSupplementaryView: { (dataSource, collectionView, elementKind, indexPath) -> UICollectionReusableView in
            switch elementKind {
            case UICollectionView.elementKindSectionHeader:
                if let header = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind,
                                                                                      withReuseIdentifier: "NoticeDetailHeaderView",
                                                                                      for: indexPath) as? NoticeDetailHeaderView {
                    header.update(model: dataSource[indexPath.section].model)
                    return header

                } else { return UICollectionReusableView() }

            default:
                return UICollectionReusableView()
            }
        })
        return dataSource
    }

    private func configureUI() {
        self.view.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
        closeButton.setImage(DesignSystemAsset.Navigation.crossClose.image, for: .normal)
        let attributedString: NSAttributedString = NSAttributedString(
            string: "공지사항",
            attributes: [.font: DesignSystemFontFamily.Pretendard.medium.font(size: 16),
                         .foregroundColor: DesignSystemAsset.GrayColor.gray900.color,
                         .kern: -0.5]
        )
        self.titleStringLabel.attributedText = attributedString
        collectionView.register(UINib(nibName: "NoticeCollectionViewCell", bundle: CommonFeatureResources.bundle),
                                forCellWithReuseIdentifier: "NoticeCollectionViewCell")
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

extension NoticeDetailViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sideSpace: CGFloat = 20
        let width = APP_WIDTH()-(sideSpace*2.0)
        return CGSize(width: width, height: width)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sideSpace: CGFloat = 20
        return UIEdgeInsets(top: 20, left: sideSpace, bottom: 20, right: sideSpace)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               referenceSizeForHeaderInSection section: Int) -> CGSize{
        let model: FetchNoticeEntity = viewModel.output.dataSource.value[section].model
        return CGSize(width: APP_WIDTH(), height: NoticeDetailHeaderView.getCellHeight(model: model))
    }
}
