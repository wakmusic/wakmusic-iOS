//
//  Extension+UIPanGestureRecognizer.swift
//  Utility
//
//  Created by KTH on 2023/01/02.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import UIKit

public extension UIPanGestureRecognizer {
    struct PanGestureDirection: OptionSet {
        public let rawValue: UInt8

        public init(rawValue: UInt8) {
            self.rawValue = rawValue
        }

        public static let Up = PanGestureDirection(rawValue: 1 << 0)
        public static let Down = PanGestureDirection(rawValue: 1 << 1)
        public static let Left = PanGestureDirection(rawValue: 1 << 2)
        public static let Right = PanGestureDirection(rawValue: 1 << 3)
    }

    private func getDirectionBy(
        velocity: CGFloat,
        greater: PanGestureDirection,
        lower: PanGestureDirection
    ) -> PanGestureDirection {
        if velocity == 0 {
            return []
        }
        return velocity > 0 ? greater : lower
    }

    /// 현재 수행되는 제스쳐의 방향을 반환합니다.
    /// 이 부분 주석은 저도 좀 학습이 필요할 것 같습니다. 추후 업데이트 예정
    /// - Parameter view: 제스쳐가 적용된 뷰
    /// - Returns: PanGestureDirection
    func direction(in view: UIView) -> PanGestureDirection {
        let velocity = self.velocity(in: view)
        let yDirection = getDirectionBy(
            velocity: velocity.y,
            greater: PanGestureDirection.Down,
            lower: PanGestureDirection.Up
        )
        let xDirection = getDirectionBy(
            velocity: velocity.x,
            greater: PanGestureDirection.Right,
            lower: PanGestureDirection.Left
        )
        return xDirection.union(yDirection)
    }
}
