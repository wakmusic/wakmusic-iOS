//
//  HapticManager.swift
//  Utility
//
//  Created by YoungK on 2023/03/02.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit

// MARK: 사용 예시
// HapticManager.shared.notification(type: .warning)
// HapticManager.shared.notification(type: .error)
// HapticManager.shared.notification(type: .success)

// HapticManager.shared.impact(style: .heavy)
// HapticManager.shared.impact(style: .light)
// HapticManager.shared.impact(style: .medium)
// HapticManager.shared.impact(style: .rigid)
// HapticManager.shared.impact(style: .soft)

public class HapticManager {
    public static let shared = HapticManager()

    public func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }

    public func notification(success: Bool) {
        let generator = UINotificationFeedbackGenerator()
        success ? generator.notificationOccurred(.success) : generator.notificationOccurred(.error)
    }

    public func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
