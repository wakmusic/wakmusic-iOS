//
//  WMLabel.swift
//  DesignSystem
//
//  Created by YoungK on 11/22/23.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit

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
        self.setTextWithAttributes(lineHeight: lineHeight, kernValue: kernValue, lineSpacing: lineSpacing, lineHeightMultiple: lineHeightMultiple)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
