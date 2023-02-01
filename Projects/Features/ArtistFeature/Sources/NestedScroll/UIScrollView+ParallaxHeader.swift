//
//  UIScrollView+ParallaxHeader.swift
//  HPParallaxHeader
//
//  Created by Hien Pham on 22/05/2021.
//

import Foundation
import UIKit

private var parallaxHeaderKey: UInt8 = 0
public extension UIScrollView {
    @IBOutlet var parallaxHeader: HPParallaxHeader! {
        get {
            let value = objc_getAssociatedObject(self, &parallaxHeaderKey) as? HPParallaxHeader;
            if let unwrapped = value {
                return unwrapped
            } else {
                let newValue = HPParallaxHeader()
                self.parallaxHeader = newValue
                return newValue
            }
        }
        set {
            newValue.scrollView = self
            objc_setAssociatedObject(self, &parallaxHeaderKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
