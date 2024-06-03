//
//  LyricDecoratingViewController+Bind.swift
//  LyricHighlightingFeature
//
//  Created by KTH on 6/3/24.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import DesignSystem
import Foundation
import RxCocoa
import RxSwift
import UIKit

extension LyricDecoratingViewController {
    func inputBind() {
        input.fetchBackgroundImage.onNext(())

        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        collectionView.rx.itemSelected
            .map { $0.item }
            .bind(to: input.didTapBackground)
            .disposed(by: disposeBag)

        backButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)

        saveButton.rx.tap
            .bind(with: self) { owner, _ in
                let activityViewController = UIActivityViewController(
                    activityItems: [owner.decorateShareContentView.asImage],
                    applicationActivities: nil
                )
                activityViewController.popoverPresentationController?.sourceRect = CGRect(
                    x: owner.view.bounds.midX,
                    y: owner.view.bounds.midY,
                    width: 0,
                    height: 0
                )
                activityViewController.popoverPresentationController?.permittedArrowDirections = []
                owner.present(activityViewController, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }

    func outputBind() {
        output.dataSource
            .skip(1)
            .do(onNext: { [decorateImageView] entities in
                decorateImageView.backgroundColor = entities.filter { $0.isSelected }.first?
                    .imageColor ?? DesignSystemAsset.PrimaryColorV2.point.color
            })
            .bind(to: collectionView.rx.items) { collectionView, index, model in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "\(LyricDecoratingCell.self)",
                    for: IndexPath(item: index, section: 0)
                ) as? LyricDecoratingCell else {
                    return UICollectionViewCell()
                }
                cell.update(model: model, index: index)
                return cell
            }
            .disposed(by: disposeBag)

        output.highlightingItems
            .bind(with: self) { owner, lyric in
                let style = NSMutableParagraphStyle()
                style.alignment = .center
                style.lineSpacing = 8
                let attributedString = NSMutableAttributedString(
                    string: lyric,
                    attributes: [
                        .font: DesignSystemFontFamily.Pretendard.medium.font(size: 18),
                        .foregroundColor: UIColor.white,
                        .kern: -0.5,
                        .paragraphStyle: style
                    ]
                )
                owner.highlightingLyricLabel.attributedText = attributedString
            }
            .disposed(by: disposeBag)
    }
}
