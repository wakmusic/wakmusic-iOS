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
    
    private lazy var lyricsLabel = WMLabel(text: "가사", textColor: DesignSystemAsset.GrayColor.gray500.color, font: .t6(weight: .medium), alignment: .center, lineHeight: UIFont.WMFontSystem.t6().lineHeight, kernValue: -0.5).then {
        $0.numberOfLines = 0
        $0.preferredMaxLayoutWidth = LyricsTableViewCell.lyricMaxWidth
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
    
    static func getCellHeight(lyric: String) -> CGFloat {
        let textHeight: CGFloat = lyric.heightConstraintAt(
            width: LyricsTableViewCell.lyricMaxWidth,
            font: DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        )
        let yMargin: CGFloat = 7
        return max(24, textHeight + yMargin)
    }
}
