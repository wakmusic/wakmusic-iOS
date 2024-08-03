//
//  Extension+UIView.swift
//  Utility
//
//  Created by KTH on 2023/01/09.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Combine
import Foundation
import SwiftEntryKit
import UIKit

public extension UIView {
    enum StartDirection: CGFloat {
        case up = -1
        case down = 1
        case random
    }

    enum VerticalLocation {
        case bottom
        case top
        case left
        case right
    }

    func tapPublisher() -> AnyPublisher<Void, Never> {
        return UITapGestureRecognizer.GesturePublisher(recognizer: .init(), view: self)
            .map { _ in }
            .eraseToAnyPublisher()
    }

    /// 1초 이내 첫 이벤트를 제외한 나머지 이벤트는 무시하는 Publisher 입니다.
    func throttleTapPublisher() -> AnyPublisher<Void, Never> {
        return UITapGestureRecognizer.GesturePublisher(recognizer: .init(), view: self)
            .throttle(
                for: .seconds(1),
                scheduler: RunLoop.main,
                latest: false
            )
            .map { _ in }
            .eraseToAnyPublisher()
    }

    func addShadow(location: VerticalLocation, color: UIColor = .black, opacity: Float = 0.8, radius: CGFloat = 5.0) {
        switch location {
        case .bottom:
            addShadow(offset: CGSize(width: 0, height: 10), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -10), color: color, opacity: opacity, radius: radius)
        case .left:
            addShadow(offset: CGSize(width: -10, height: 0), color: color, opacity: opacity, radius: radius)
        case .right:
            addShadow(offset: CGSize(width: 10, height: 0), color: color, opacity: opacity, radius: radius)
        }
    }

    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.1, radius: CGFloat = 3.0) {
        // 테두리 밖으로 contents가 있을 때, 마스킹(true)하여 표출안되게 할것인지 마스킹을 off(false  emptyView.layer.masksToBounds = false
        // shadow 색상
        // 현재 shadow는 view의 layer 테두리와 동일한 위치로 있는 상태이므로 offset을 통해 그림자를 이동시켜야 표출
        // shadow의 투명도 (0 ~ 1)
        // shadow의 corner radius
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }

    func animateSizeDownToUp(timeInterval: TimeInterval) {
        let propertyAnimator = UIViewPropertyAnimator(duration: timeInterval, dampingRatio: 0.5) {
            self.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
        }
        propertyAnimator.addAnimations({ self.transform = .identity }, delayFactor: CGFloat(timeInterval))
        propertyAnimator.startAnimation()
    }

    func showToast(text: String, font: UIFont) {
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

    func parentViewController() -> UIViewController? {
        var parentResponder: UIResponder? = self
        while true {
            guard let nextResponder = parentResponder?.next else { return nil }
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            parentResponder = nextResponder
        }
    }

    func addSubviews(_ views: UIView...) {
        views.forEach(self.addSubview(_:))
    }

    var asImage: UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }

    func asImage(size: CGSize? = nil) -> UIImage {
        let originalSize = bounds.size
        let targetSize = size ?? originalSize
        let rendererFormat = UIGraphicsImageRendererFormat.default()
        rendererFormat.scale = 1.0

        let renderer = UIGraphicsImageRenderer(size: targetSize, format: rendererFormat)
        return renderer.image { rendererContext in
            let scaleX = targetSize.width / originalSize.width
            let scaleY = targetSize.height / originalSize.height
            rendererContext.cgContext.scaleBy(x: scaleX, y: scaleY)
            layer.render(in: rendererContext.cgContext)
        }
    }

    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        layer.add(animation, forKey: nil)
    }

    func moveAnimate(
        duration: CGFloat,
        amount: CGFloat,
        direction: StartDirection
    ) {
        let directionValue = (direction == .random) ? ((Array(0 ... 1).randomElement() ?? 0) == 0 ? 1 : -1) : direction
            .rawValue
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: [.autoreverse, .repeat],
            animations: {
                self.transform = CGAffineTransform(translationX: 0, y: amount * directionValue)
            },
            completion: nil
        )
    }

    func removeAllAnimations() {
        self.layer.removeAllAnimations()
        self.transform = .identity
    }
}
