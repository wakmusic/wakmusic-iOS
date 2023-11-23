//
//  WMLabel.swift
//  DesignSystem
//
//  Created by YoungK on 11/22/23.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import MarqueeLabel

public final class WMLabel: UILabel {
    public init(
        text: String = "",
        textColor: UIColor = .init(),
        font: UIFont.WMFontSystem = .body1,
        alignment: NSTextAlignment = .left,
        lineHeight: CGFloat? = nil,
        kernValue: Double? = nil,
        lineSpacing: CGFloat? = nil,
        lineHeightMultiple: CGFloat? = nil
    ) {
        super.init(frame: .zero)
        self.text = text
        self.textColor = textColor
        self.font = .setFont(font)
        self.textAlignment = alignment
        self.setTextWithAttributes(lineHeight: lineHeight, kernValue: kernValue, lineSpacing: lineSpacing, lineHeightMultiple: lineHeightMultiple, alignment: alignment)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public final class WMFlowLabel: MarqueeLabel {
    public init(
        text: String = "",
        textColor: UIColor = .init(),
        font: UIFont.WMFontSystem = .body1,
        alignment: NSTextAlignment = .left,
        lineHeight: CGFloat? = nil,
        kernValue: Double? = nil,
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
        self.setTextWithAttributes(lineHeight: lineHeight, kernValue: kernValue, lineSpacing: lineSpacing, lineHeightMultiple: lineHeightMultiple, alignment: alignment)
        self.leadingBuffer = leadingBuffer
        self.trailingBuffer = trailingBuffer
        self.animationDelay = animationDelay
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
