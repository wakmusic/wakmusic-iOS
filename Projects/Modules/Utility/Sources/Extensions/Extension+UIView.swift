//
//  Extension+UIView.swift
//  Utility
//
//  Created by KTH on 2023/01/09.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import UIKit
import SwiftEntryKit

public extension UIView {
    
    func animateSizeDownToUp(timeInterval: TimeInterval) {
        let propertyAnimator = UIViewPropertyAnimator(duration: timeInterval, dampingRatio: 0.5) {
            self.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
        }
        propertyAnimator.addAnimations({ self.transform = .identity }, delayFactor: CGFloat(timeInterval))
        propertyAnimator.startAnimation()
    }
    
    func showToast(text: String) {
        var attributes = EKAttributes.bottomFloat
        attributes.displayDuration = 2
        attributes.entryBackground = .color(color: EKColor(rgb: 0x101828).with(alpha: 0.8))
        attributes.roundCorners = .all(radius: 20)

        let style = EKProperty.LabelStyle(
            font: .systemFont(ofSize: 14, weight: .light),
            color: EKColor(rgb: 0xFCFCFD),
            alignment: .center
        )
        let labelContent = EKProperty.LabelContent(
            text: text,
            style: style
        )

        let contentView = EKNoteMessageView(with: labelContent)
        contentView.verticalOffset = 10
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
}
