//
//  HPScrollViewDelegateForwarder.swift
//  HPParallaxHeader
//
//  Created by Hien Pham on 29/05/2021.
//

import UIKit

@objc class HPScrollViewDelegateForwarder: NSObject, HPScrollViewDelegate {
    
    @objc weak var delegate: HPScrollViewDelegate?
    @objc weak var scrollView: HPScrollView!
    
    init(scrollView: HPScrollView) {
        self.scrollView = scrollView
    }
    
    @objc public func scrollViewShouldScroll(_ scrollView: HPScrollView, with subView: UIScrollView) -> Bool {
        return delegate?.scrollViewShouldScroll(scrollView, with: subView) ?? true
    }

    @objc func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll?(scrollView)
    }
    
    @objc func scrollViewDidZoom(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidZoom?(scrollView)
    }
    
    @objc func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    @objc func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                                withVelocity velocity: CGPoint,
                                                targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.scrollViewWillEndDragging?(scrollView,
                                             withVelocity: velocity,
                                             targetContentOffset: targetContentOffset)
    }
    
    @objc func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.scrollView.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
        delegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    @objc func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        delegate?.scrollViewWillBeginDecelerating?(scrollView)
    }
    
    @objc func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollView.scrollViewDidEndDecelerating(scrollView)
        delegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    @objc func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
    
    @objc func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return delegate?.viewForZooming?(in: scrollView)
    }
    
    @objc func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        delegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }
    
    @objc func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        delegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }
    
    @objc func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        let isScrollToTop = delegate?.scrollViewShouldScrollToTop?(scrollView) ?? scrollView.scrollsToTop
        if isScrollToTop == true {
            self.scrollView.hpScrollsToTop(animated: true)
        }
        return false
    }
    
    @objc func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScrollToTop?(scrollView)
    }
    
    @available(iOS 11.0, *)
    @objc func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidChangeAdjustedContentInset?(scrollView)
    }
}
