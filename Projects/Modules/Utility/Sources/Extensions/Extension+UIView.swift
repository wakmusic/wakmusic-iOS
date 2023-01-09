//
//  Extension+UIView.swift
//  Utility
//
//  Created by KTH on 2023/01/09.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    
    func animateSizeDownToUp(timeInterval: TimeInterval) {
        let propertyAnimator = UIViewPropertyAnimator(duration: timeInterval, dampingRatio: 0.5) {
            self.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
        }
        propertyAnimator.addAnimations({ self.transform = .identity }, delayFactor: CGFloat(timeInterval))
        propertyAnimator.startAnimation()
    }
}
