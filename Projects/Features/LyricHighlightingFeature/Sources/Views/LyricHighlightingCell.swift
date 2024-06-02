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

final class LyricHighlightingCell: UICollectionViewCell {
    var lyricLabel = UILabel().then {
        $0.textColor = .white
        $0.font = DesignSystemFontFamily.Pretendard.light.font(size: 18)
        $0.setTextWithAttributes(alignment: .center)
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
    func update(entity: LyricsEntity) {}
}

private extension LyricHighlightingCell {
    func addSubViews() {
        contentView.addSubview(lyricLabel)
    }

    func setAutoLayout() {
        lyricLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
