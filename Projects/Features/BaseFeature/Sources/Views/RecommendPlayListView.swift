//
//  RecommendPlayListView.swift
//  HomeFeature
//
//  Created by KTH on 2023/01/07.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DesignSystem
import PlaylistDomainInterface
import UIKit
import Utility

public protocol RecommendPlayListViewDelegate: AnyObject {
    func itemSelected(model: RecommendPlaylistEntity)
}

public class RecommendPlayListView: UIView {
    @IBOutlet weak var titleStringLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    public weak var delegate: RecommendPlayListViewDelegate?

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }

    public var dataSource: [RecommendPlaylistEntity] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
}

public extension RecommendPlayListView {
    private func setupView() {
        guard let view = Bundle.module.loadNibNamed("RecommendPlayListView", owner: self, options: nil)?
            .first as? UIView else { return }
        view.frame = self.bounds
        view.layoutIfNeeded()
        self.addSubview(view)

        // xib로 만든 UI를 컬렉션 뷰에서 사용하기 위해서는 등록이 필요
        collectionView.register(
            UINib(nibName: "RecommendPlayListCell", bundle: BaseFeatureResources.bundle),
            forCellWithReuseIdentifier: "RecommendPlayListCell"
        )
        collectionView.dataSource = self
        collectionView.delegate = self

        let attributedString = NSMutableAttributedString(
            string: "왁뮤팀이 추천하는 리스트",
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.bold.font(size: 16),
                .foregroundColor: DesignSystemAsset.GrayColor.gray900.color,
                .kern: -0.5
            ]
        )
        titleStringLabel.attributedText = attributedString
    }

    static func getViewHeight(model: [RecommendPlaylistEntity]) -> CGFloat {
        guard !model.isEmpty else {
            return 0
        }

        let base: CGFloat = 32 + 24 + 20 + 32
        let spacing: CGFloat = 8.0

        let itemWidth: CGFloat = (APP_WIDTH() - (20 + 8 + 20)) / 2.0
        let itemHeight: CGFloat = (80.0 * itemWidth) / 164.0

        let mok: Int = model.count / 2
        let remain: Int = model.count % 2

        if model.count == 1 {
            return base + itemHeight

        } else {
            if remain == 0 {
                return base + (CGFloat(mok) * itemHeight) + (CGFloat(mok - 1) * spacing)
            } else {
                return base + (CGFloat(mok) * itemHeight) + (CGFloat(remain) * itemHeight) +
                    (CGFloat(mok - 1) * spacing) + (CGFloat(remain) * spacing)
            }
        }
    }
}

extension RecommendPlayListView: UICollectionViewDataSource, UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.itemSelected(model: self.dataSource[indexPath.row])
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let itemWidth: CGFloat = (APP_WIDTH() - (20 + 8 + 20)) / 2.0
        let itemHeight: CGFloat = (80.0 * itemWidth) / 164.0
        return CGSize(width: itemWidth, height: itemHeight)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "RecommendPlayListCell",
            for: indexPath
        ) as? RecommendPlayListCell else {
            return UICollectionViewCell()
        }
        let model = self.dataSource[indexPath.row]
        cell.update(model: model)
        return cell
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 8
    }
}
