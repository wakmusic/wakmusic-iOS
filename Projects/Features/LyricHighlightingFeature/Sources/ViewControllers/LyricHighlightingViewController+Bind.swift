//
//  LyricHighlightingViewController+Bind.swift
//  LyricHighlightingFeature
//
//  Created by KTH on 6/3/24.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import DesignSystem
import Foundation
import LogManager
import UIKit

extension LyricHighlightingViewController {
    func inputBind() {
        input.fetchLyric.onNext(())

        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        collectionView.rx.itemSelected
            .map { $0.item }
            .bind(to: input.didTapHighlighting)
            .disposed(by: disposeBag)

        backButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)

        saveButton.rx.tap
            .bind(to: input.didTapSaveButton)
            .disposed(by: disposeBag)
    }

    func outputBind() {
        output.dataSource
            .skip(1)
            .do(onNext: { [indicator] _ in
                indicator.stopAnimating()
            })
            .bind(to: collectionView.rx.items) { collectionView, index, entity in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "\(LyricHighlightingCell.self)",
                    for: IndexPath(item: index, section: 0)
                ) as? LyricHighlightingCell else {
                    return UICollectionViewCell()
                }
                cell.update(entity: entity)
                return cell
            }
            .disposed(by: disposeBag)

        output.isStorable
            .bind(with: self) { owner, isStorable in
                let color = isStorable ? DesignSystemAsset.PrimaryColorV2.point.color : DesignSystemAsset.NewGrayColor
                    .gray900.color
                owner.saveButtonContentView.backgroundColor = color
                let image = isStorable ? DesignSystemAsset.LyricHighlighting.lyricHighlightSaveOn.image : DesignSystemAsset.LyricHighlighting.lyricHighlightSaveOff.image
                owner.saveButton.setImage(image, for: .normal)
            }
            .disposed(by: disposeBag)

        output.goDecoratingScene
            .skip(1)
            .bind(with: self) { owner, items in
                let viewController = owner.lyricDecoratingComponent.makeView(
                    model: .init(title: "리와인드 (RE:WIND)", artist: "이세계아이돌", highlightingItems: items)
                )
                owner.navigationController?.pushViewController(viewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
