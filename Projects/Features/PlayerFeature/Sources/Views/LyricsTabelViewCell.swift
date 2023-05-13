//
//  LyricsTabelViewCell.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/01/11.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import DesignSystem
import SnapKit
import Then
import Utility

internal class LyricsTableViewCell: UITableViewCell {
    static let identifier = "LyricsTableViewCell"
    static let lyricMaxWidth: CGFloat = (270 * APP_WIDTH())/375.0

    private lazy var lyricsLabel = UILabel().then {
        $0.font = .init(font: DesignSystemFontFamily.Pretendard.medium, size: 14)
        $0.textColor = DesignSystemAsset.GrayColor.gray500.color
        $0.setLineSpacing(kernValue: -0.5, lineHeightMultiple: 1.44)
        $0.text = ""
        $0.numberOfLines = 0
        $0.preferredMaxLayoutWidth = LyricsTableViewCell.lyricMaxWidth
        $0.textAlignment = .center
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureContents()
    }

    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    private func configureContents() {
        self.backgroundColor = .clear
        self.contentView.addSubview(self.lyricsLabel)
        lyricsLabel.snp.makeConstraints {
            $0.centerX.equalTo(contentView.snp.centerX)
            $0.centerY.equalTo(contentView.snp.centerY)
        }
    }
    
    override func prepareForReuse() {
        highlight(false)
    }
    
    internal func setLyrics(text: String) {
        self.lyricsLabel.text = text
    }
    
    internal func highlight(_ isCurrent: Bool) {
        lyricsLabel.textColor = isCurrent ? DesignSystemAsset.PrimaryColor.point.color : DesignSystemAsset.GrayColor.gray500.color
    }
}
