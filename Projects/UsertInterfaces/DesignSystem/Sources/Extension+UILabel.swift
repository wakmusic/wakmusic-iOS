//
//  Extension+UILabel.swift
//  Utility
//
//  Created by YoungK on 2023/01/09.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit

public extension UILabel {
    @available(*, deprecated, renamed: "setTextWithAttributes", message: "setLineSpacing과 setLineHeight 통합됨")
    /// 레이블의 높이, 자간, 행간을 조절하는 메소드입니다.
    /// - Parameter kernValue: 글자간의 간격
    /// - Parameter lineSpacing: 줄 간격 (한 줄과 다음 줄 사이의 간격)
    /// - Parameter lineHeightMultiple: 줄 간격의 배수 (lineSpacing *  lineHeightMultiple)
    func setLineSpacing(
        kernValue: Double = 0.0,
        lineSpacing: CGFloat = 0.0,
        lineHeightMultiple: CGFloat = 0.0
    ) {
        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.lineBreakMode = .byTruncatingTail

        let attributedString = NSMutableAttributedString(
            string: labelText,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .kern: kernValue
            ]
        )

        self.attributedText = attributedString
    }

    @available(*, deprecated, renamed: "setTextWithAttributes", message: "setLineSpacing과 setLineHeight 통합됨")
    func setLineHeight(lineHeight: CGFloat) {
        if let text = self.text {
            let style = NSMutableParagraphStyle()
            style.maximumLineHeight = lineHeight
            style.minimumLineHeight = lineHeight

            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: style,
                .baselineOffset: (lineHeight - font.lineHeight) / 2
            ]
            let attrString = NSAttributedString(
                string: text,
                attributes: attributes
            )
            self.attributedText = attrString
        }
    }

    /// 레이블의 높이, 자간, 행간을 조절하는 메소드입니다.
    /// - Parameter lineHeight: 레이블 자체의 높이
    /// - Parameter kernValue: 글자간의 간격
    /// - Parameter lineSpacing: 줄 간격 (한 줄과 다음 줄 사이의 간격)
    /// - Parameter lineHeightMultiple: 줄 간격의 배수 (lineSpacing *  lineHeightMultiple)
    func getTextWithAttributes(
        lineHeight: CGFloat? = nil,
        lineBreakMode: NSLineBreakMode = .byTruncatingTail,
        kernValue: Double? = nil,
        lineSpacing: CGFloat? = nil,
        lineHeightMultiple: CGFloat? = nil,
        alignment: NSTextAlignment = .left
    ) -> [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()

        if let lineSpacing { paragraphStyle.lineSpacing = lineSpacing }
        if let lineHeightMultiple { paragraphStyle.lineHeightMultiple = lineHeightMultiple }

        paragraphStyle.lineBreakMode = lineBreakMode
        paragraphStyle.alignment = alignment

        let baselineOffset: CGFloat
        let offsetDivisor: CGFloat

        if #available(iOS 16.4, *) { // 16.4 부터 잠수함 패치로 고쳐졌다고 합니다.
            offsetDivisor = 2
        } else {
            offsetDivisor = 4
        }

        if let lineHeight {
            paragraphStyle.maximumLineHeight = lineHeight
            paragraphStyle.minimumLineHeight = lineHeight
            baselineOffset = (lineHeight - font.lineHeight) / offsetDivisor
        } else {
            baselineOffset = 0
        }

        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .kern: kernValue ?? 0.0,
            .baselineOffset: baselineOffset
        ]

        return attributes
    }

    func setTextWithAttributes(
        lineHeight: CGFloat? = nil,
        lineBreakMode: NSLineBreakMode = .byTruncatingTail,
        kernValue: Double? = -0.5,
        lineSpacing: CGFloat? = nil,
        lineHeightMultiple: CGFloat? = nil,
        alignment: NSTextAlignment = .left,
        hangulWordPriority: Bool = false
    ) {
        let paragraphStyle = NSMutableParagraphStyle()

        if let lineSpacing { paragraphStyle.lineSpacing = lineSpacing }
        if let lineHeightMultiple { paragraphStyle.lineHeightMultiple = lineHeightMultiple }

        paragraphStyle.lineBreakMode = lineBreakMode
        paragraphStyle.alignment = alignment

        if hangulWordPriority {
            paragraphStyle.lineBreakStrategy = .hangulWordPriority
        }

        let baselineOffset: CGFloat
        let offsetDivisor: CGFloat

        if #available(iOS 16.4, *) { // 16.4 부터 잠수함 패치로 고쳐졌다고 합니다.
            offsetDivisor = 2
        } else {
            offsetDivisor = 4
        }

        if let lineHeight {
            paragraphStyle.maximumLineHeight = lineHeight
            paragraphStyle.minimumLineHeight = lineHeight
            baselineOffset = (lineHeight - font.lineHeight) / offsetDivisor
        } else {
            baselineOffset = 0
        }

        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .kern: kernValue ?? 0.0,
            .baselineOffset: baselineOffset
        ]
        let attributedString = NSMutableAttributedString(string: text ?? "", attributes: attributes)

        self.attributedText = attributedString
    }
}
