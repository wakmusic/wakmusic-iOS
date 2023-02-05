//
//  HPParallaxView.swift
//  HPParallaxHeader
//
//  Created by Hien Pham on 19/05/2021.
//

import Foundation
import UIKit

class HPParallaxView: UIView {
    static var KVOContext = "kHPParallaxViewKVOContext"
    
    weak var parent: HPParallaxHeader?
    
    override func willMove(toSuperview newSuperview: UIView?) {
        defer { super.willMove(toSuperview: newSuperview) }
        guard let superView = self.superview as? UIScrollView,
              let parent = parent else { return }
        superView.removeObserver(parent, forKeyPath: #keyPath(UIScrollView.contentOffset), context: &HPParallaxView.KVOContext)
        if #available(*, iOS 10) {
            superView.removeObserver(parent, forKeyPath: #keyPath(UIScrollView.contentInset), context: &HPParallaxView.KVOContext)
        }
    }
    
    override func didMoveToSuperview() {
        defer { super.didMoveToSuperview() }
        guard let superView = self.superview as? UIScrollView,
              let parent = parent else { return }
        superView.addObserver(parent,
                              forKeyPath: #keyPath(UIScrollView.contentOffset),
                              context: &HPParallaxView.KVOContext)
        if #available(*, iOS 10) {
            superView.addObserver(parent,
                                  forKeyPath: #keyPath(UIScrollView.contentInset),
                                  context: &HPParallaxView.KVOContext)
        }
    }
}
