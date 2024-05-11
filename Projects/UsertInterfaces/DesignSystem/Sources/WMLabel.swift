//
//  WMLabel.swift
//  DesignSystem
//
//  Created by YoungK on 11/22/23.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import MarqueeLabel
import UIKit

public final class WMLabel: UILabel {
    public init(
        text: String,
        textColor: UIColor = .init(),
        font: UIFont.WMFontSystem,
        alignment: NSTextAlignment = .left,
        lineHeight: CGFloat? = nil,
        kernValue: Double? = -0.5,
        lineSpacing: CGFloat? = nil,
        lineHeightMultiple: CGFloat? = nil
    ) {
        super.init(frame: .zero)
        self.text = text
        self.textColor = textColor
        self.font = .setFont(font)
        self.textAlignment = alignment
        self.setTextWithAttributes(
            lineHeight: lineHeight,
            kernValue: kernValue,
            lineSpacing: lineSpacing,
            lineHeightMultiple: lineHeightMultiple,
            alignment: alignment
        )
    }

    convenience init(
        text: String,
        textColor: UIColor = .init(),
        font: UIFont.WMFontSystem,
        alignment: NSTextAlignment = .left,
        lineHeight: CGFloat? = nil,
        kernValue: Double? = 0.5
    ) {
        self.init(
            text: text,
            textColor: textColor,
            font: font,
            alignment: alignment,
            lineHeight: lineHeight,
            kernValue: kernValue,
            lineSpacing: nil,
            lineHeightMultiple: nil
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
