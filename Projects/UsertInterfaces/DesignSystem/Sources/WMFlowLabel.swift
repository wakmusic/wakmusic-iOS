//
//  WMFlowLabel.swift
//  DesignSystem
//
//  Created by YoungK on 11/25/23.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import MarqueeLabel
import UIKit

public final class WMFlowLabel: MarqueeLabel {
    public init(
        text: String = "",
        textColor: UIColor = .init(),
        font: UIFont.WMFontSystem,
        alignment: NSTextAlignment = .left,
        lineHeight: CGFloat? = nil,
        kernValue: Double? = -0.5,
        lineSpacing: CGFloat? = nil,
        lineHeightMultiple: CGFloat? = nil,
        leadingBuffer: CGFloat = 0,
        trailingBuffer: CGFloat = 0,
        animationDelay: CGFloat = 1,
        animationSpeed: CGFloat = 30,
        fadeLength: CGFloat = 3
    ) {
        super.init(frame: .zero, rate: animationSpeed, fadeLength: fadeLength)
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
        self.leadingBuffer = leadingBuffer
        self.trailingBuffer = trailingBuffer
        self.animationDelay = animationDelay
    }

    convenience init(
        text: String,
        textColor: UIColor = .init(),
        font: UIFont.WMFontSystem,
        alignment: NSTextAlignment = .left,
        lineHeight: CGFloat? = nil,
        kernValue: Double? = nil,
        leadingBuffer: CGFloat = 0,
        trailingBuffer: CGFloat = 0,
        animationDelay: CGFloat = 1,
        animationSpeed: CGFloat = 30,
        fadeLength: CGFloat = 3
    ) {
        self.init(
            text: text,
            textColor: textColor,
            font: font,
            alignment: alignment,
            lineHeight: lineHeight,
            kernValue: kernValue,
            lineSpacing: nil,
            lineHeightMultiple: nil,
            leadingBuffer: leadingBuffer,
            trailingBuffer: trailingBuffer,
            animationDelay: animationDelay,
            animationSpeed: animationSpeed,
            fadeLength: fadeLength
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
