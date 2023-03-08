//
//  Extension+UIScrollView.swift
//  Utility
//
//  Created by yongbeomkwak on 2023/03/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import UIKit


public extension UIScrollView {
    func scrollToView(view: UIView,
                          position: UITableView.ScrollPosition = .top,
                          animated: Bool = true) {

            // Position 'None' should not scroll view to top if visible like in UITableView
            if position == .none &&
                bounds.intersects(view.frame) {
                return
            }

            if let origin = view.superview {
                // Get the subview's start point relative to the current UIScrollView
                let childStartPoint = origin.convert(view.frame.origin,
                                                     to: self)
                var scrollPointY: CGFloat
                switch position {
                case .bottom:
                    let childEndY = childStartPoint.y + view.frame.height
                    scrollPointY = CGFloat.maximum(childEndY - frame.size.height, 0)
                case .middle:
                    let childCenterY = childStartPoint.y + view.frame.height / 2.0
                    let scrollViewCenterY = frame.size.height / 2.0
                    scrollPointY = CGFloat.maximum(childCenterY - scrollViewCenterY, 0)
                default:
                    // Scroll to top
                    scrollPointY = childStartPoint.y
                }

                // Scroll to the calculated Y point
                scrollRectToVisible(CGRect(x: 0,
                                           y: scrollPointY,
                                           width: 1,
                                           height: frame.height),
                                    animated: animated)
            }
        }
}
