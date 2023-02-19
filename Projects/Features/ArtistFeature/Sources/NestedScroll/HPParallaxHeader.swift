//
//  HPParallaxHeader.swift
//  HPParallaxHeader
//
//  Created by Hien Pham on 06/03/2021.
//

import Foundation
import UIKit

public enum HPParallaxHeaderMode {
    /**
     The option to scale the content to fill the size of the header. Some portion of the content may be clipped to fill the header’s bounds.
     */
    case fill
    /**
     The option to scale the content to fill the size of the header and aligned at the top in the header's bounds.
     */
    case topFill
    /**
     The option to center the content aligned at the top in the header's bounds.
     */
    case top
    /**
     The option to center the content in the header’s bounds, keeping the proportions the same.
     */
    case center
    /**
     The option to center the content aligned at the bottom in the header’s bounds.
     */
    case bottom
}

public protocol HPParallaxHeaderDelegate: AnyObject {
    /**
     Tells the header view that the parallax header did scroll.
     The view typically implements this method to obtain the change in progress from parallaxHeaderView.

     @param parallaxHeader The parallax header that scrolls.
     */
    func parallaxHeaderDidScroll(_ parallaxHeader: HPParallaxHeader)
}

open class HPParallaxHeader: NSObject {
    /**
     The content view on top of the UIScrollView's content.
     */
    public var contentView: UIView {
        if let contentView = _contentView {
            return contentView
        }
        let contentView = HPParallaxView()
        contentView.parent = self
        contentView.clipsToBounds = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        heightConstraint = contentView.heightAnchor.constraint(equalToConstant: 0)
        _contentView = contentView
        return contentView
    }
    private var _contentView: UIView?
    
    /**
     Delegate instance that adopt the MXScrollViewDelegate.
     */
    public weak var delegate: HPParallaxHeaderDelegate?
    
    /**
     The header's view.
     */
    @IBOutlet public var view: UIView? {
        get {
            return _view
        }
        set {
            if (newValue != _view) {
                _view?.removeFromSuperview()
                _view = newValue

                updateConstraints()

                contentView.layoutIfNeeded()

                height = contentView.frame.size.height;
                heightConstraint?.constant = height
                heightConstraint?.isActive = true
            }

        }
    }
    private var _view: UIView?

    /**
     The header's default height. 0 by default.
     */
    @IBInspectable public var height: CGFloat = 0 {
        didSet {
            if (height != oldValue) {

                //Adjust content inset
                adjustScrollViewTopInset((scrollView?.contentInset.top ?? 0) - oldValue + height)

                heightConstraint?.constant = height
                heightConstraint?.isActive = true
                layoutContentView()
            }
        }
    }

    /**
     The header's minimum height while scrolling up. 0 by default.
     */
    @IBInspectable @objc public dynamic var minimumHeight: CGFloat = 0 {
        didSet {
            layoutContentView()
        }
    }
    
    /**
     The parallax header behavior mode.
     */
    public var mode: HPParallaxHeaderMode = .fill {
        didSet {
            if (mode != oldValue) {
                updateConstraints()
            }

        }
    }
    /**
     The parallax header progress value.
     */
    public private(set) var progress: CGFloat = 0 {
        didSet {
            if (oldValue != progress) {
                delegate?.parallaxHeaderDidScroll(self)
            }
        }
    }
    
    /**
     Loads a `view` from the nib file in the specified bundle.

     @param name The name of the nib file, without any leading path information.
     @param bundleOrNil The bundle in which to search for the nib file. If you specify nil, this method looks for the nib file in the main bundle.
     @param optionsOrNil A dictionary containing the options to use when opening the nib file. For a list of available keys for this dictionary, see NSBundle UIKit Additions.
     */
    public func load(nibName name: String, bundle bundleOrNil: Bundle?, options: [UINib.OptionsKey: Any]) {
        let nib = UINib(nibName: name, bundle: bundleOrNil)
        nib.instantiate(withOwner: self, options: options)
    }
    
    weak var scrollView: UIScrollView? {
        didSet {
            if oldValue != scrollView {
                isObserving = true
            }
        }
    }
    
    private var positionConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    private var isObserving: Bool = false
    
    // MARK: - Constraints
    func updateConstraints() {
        guard let view = view else { return }
        
        contentView.removeFromSuperview()
        scrollView?.addSubview(contentView)
        
        view.removeFromSuperview()
        contentView.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        switch self.mode {
        case .fill:
            setFillModeConstraints()
        case .topFill:
            setTopFillModeConstraints()
        case .top:
            setTopModeConstraints()
        case .bottom:
            setBottomModeConstraints()
        case .center:
            setCenterModeConstraints()
        }

        setContentViewConstraints()
    }

    func setCenterModeConstraints() {
        view?.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        view?.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        view?.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        view?.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
    }
    
    func setFillModeConstraints() {
        view?.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        view?.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        view?.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        view?.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func setTopFillModeConstraints() {
        view?.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        view?.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        view?.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        view?.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        
        let constraint = view?.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        constraint?.priority = .defaultHigh
        constraint?.isActive = true
    }

    func setTopModeConstraints() {
        view?.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        view?.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        view?.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        view?.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func setBottomModeConstraints() {
        view?.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        view?.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        view?.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        view?.heightAnchor.constraint(equalToConstant: height).isActive = true
    }

    func setContentViewConstraints() {
        guard let scrollView = scrollView else { return }
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        positionConstraint = contentView.topAnchor.constraint(equalTo: scrollView.topAnchor)
        positionConstraint?.isActive = true
    }
    
    // MARK: - Private Methods
    

    private func layoutContentView() {
        let minimumHeightReal = min(minimumHeight, height);
        let relativeYOffset = (scrollView?.contentOffset.y ?? 0) + (scrollView?.contentInset.top ?? 0) - height
        let relativeHeight  = -relativeYOffset;

        positionConstraint?.constant = relativeYOffset
        heightConstraint?.constant = max(relativeHeight, minimumHeightReal)

        contentView.layoutSubviews()
        
        let div = height - minimumHeightReal
        progress = ((heightConstraint?.constant ?? 0) - minimumHeightReal) / (div != 0 ? div : height)
    }
    
    private func adjustScrollViewTopInset(_ top: CGFloat) {
        var inset = scrollView?.contentInset ?? .zero

        //Adjust content offset
        var offset = scrollView?.contentOffset ?? .zero
        offset.y += inset.top - top
        scrollView?.contentOffset = offset

        //Adjust content inset
        inset.top = top
        scrollView?.contentInset = inset
    }
    
    // MARK: - KVO
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &HPParallaxView.KVOContext {
            if keyPath == #keyPath(UIScrollView.contentOffset) {
                layoutContentView()
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}

