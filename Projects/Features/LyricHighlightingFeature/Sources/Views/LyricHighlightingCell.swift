//
//  LyricHighlightingCell.swift
//  LyricHighlightingFeature
//
//  Created by KTH on 6/1/24.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import DesignSystem
import SnapKit
import SongsDomainInterface
import Then
import UIKit
import Utility

final class LyricHighlightingCell: UICollectionViewCell {
    var lyricLabel = UILabel().then {
        $0.numberOfLines = 0
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        setAutoLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LyricHighlightingCell {
    static func cellHeight(entity: LyricsEntity) -> CGSize {
        return .init(
            width: APP_WIDTH(),
            height: entity.text.heightConstraintAt(
                width: APP_WIDTH()-50,
                font: DesignSystemFontFamily.Pretendard.light.font(size: 18)
            )
        )
    }

    func update(entity: LyricsEntity) {
        let style = NSMutableParagraphStyle()
        style.alignment = .center

        let attributedString = NSMutableAttributedString(
            string: entity.text,
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.light.font(size: 18),
                .backgroundColor: entity.isHighlighting ? DesignSystemAsset.PrimaryColorV2.point.color.withAlphaComponent(0.5) : .clear,
                .foregroundColor: UIColor.white,
                .kern: -0.5,
                .paragraphStyle: style
            ]
        )
        lyricLabel.attributedText = attributedString
    }
}

private extension LyricHighlightingCell {
    func addSubViews() {
        contentView.addSubview(lyricLabel)
    }

    func setAutoLayout() {
        lyricLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(25)
            $0.trailing.equalToSuperview().offset(-25)
        }
    }
}
