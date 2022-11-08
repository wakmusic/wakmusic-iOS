//
//  UIGestureRecognizerExt.swift
//  WaktaverseMusicFramework
//
//  Created by Fo co on 2022/11/08.
//

import Foundation
import UIKit

extension UIGestureRecognizer {

    typealias Action = ((UIGestureRecognizer) -> Void)

    private struct Keys {
        static var actionKey = "ActionKey"
    }

    private var block: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &Keys.actionKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }

        get {
            let action = objc_getAssociatedObject(self, &Keys.actionKey) as? Action
            return action
        }
    }

    @objc func handleAction(recognizer: UIGestureRecognizer) {
        block?(recognizer)
    }

    convenience public  init(block: @escaping ((UIGestureRecognizer) -> Void)) {
        self.init()
        self.block = block
        self.addTarget(self, action: #selector(handleAction(recognizer:)))
    }
}
