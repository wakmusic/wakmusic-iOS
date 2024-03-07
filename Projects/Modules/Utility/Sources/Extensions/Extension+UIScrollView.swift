//
//  Extension+UIScrollView.swift
//  Utility
//
//  Created by yongbeomkwak on 2023/03/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import UIKit

public enum ScrollDirection {
    case top
    case center
    case bottom
}

public extension UIScrollView {
    func scrollToView(view: UIView) {
        if let origin = view.superview {
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            let bottomOffset = scrollBottomOffset()

            if childStartPoint.y > bottomOffset.y {
                setContentOffset(bottomOffset, animated: true)

            } else {
                setContentOffset(CGPoint(x: 0, y: childStartPoint.y), animated: true)
            }
        }
    }

//        func scrollToTop() {
//            let topOffset = CGPoint(x: 0, y: -contentInset.top)
//            setContentOffset(topOffset, animated: true)
//        }
//
//        func scrollToBottom() {
//            let bottomOffset = scrollBottomOffset()
//            if(bottomOffset.y > 0) {
//                setContentOffset(bottomOffset, animated: true)
//            }
//        }

    private func scrollBottomOffset() -> CGPoint {
        return CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
    }

    func scroll(to direction: ScrollDirection) {
        DispatchQueue.main.async {
            switch direction {
            case .top:
                self.scrollToTop()
            case .center:
                self.scrollToCenter()
            case .bottom:
                self.scrollToBottom()
            }
        }
    }

    private func scrollToTop() {
        setContentOffset(.zero, animated: true)
    }

    private func scrollToCenter() {
        let centerOffset = CGPoint(x: 0, y: (contentSize.height - bounds.size.height) / 2)
        setContentOffset(centerOffset, animated: true)
    }

    private func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if bottomOffset.y > 0 {
            setContentOffset(bottomOffset, animated: true)
        }
    }
}
