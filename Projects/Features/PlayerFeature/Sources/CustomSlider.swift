//
//  CustomSlider.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/01/06.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit

public protocol CustomSliderDelegate: AnyObject {
    func didStartTouches(in slider: CustomSlider)
    func didEndTouches(in slider: CustomSlider)
}

public class CustomSlider: UISlider {

    public weak var delegate: CustomSliderDelegate?

    @IBInspectable var trackLineHeight: CGFloat = 2.0

    public override func trackRect(forBounds bound: CGRect) -> CGRect {
        var newRect = super.trackRect(forBounds: bounds)
        newRect.size.height = trackLineHeight
        return newRect
    }
    
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let tapPoint = touch.location(in: self)
        let fraction = Float(tapPoint.x / bounds.width)
        let newValue = (maximumValue - minimumValue) * fraction + minimumValue

        if newValue != value {
           value = newValue
           sendActions(for: .valueChanged)
        }

        delegate?.didStartTouches(in: self)

        return true
    }

    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        delegate?.didEndTouches(in: self)
    }
}
