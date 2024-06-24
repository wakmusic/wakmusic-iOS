import Foundation
import UIKit
import Utility

extension Double {
    var correctLeading: CGFloat {
        return self * APP_WIDTH() / 375.0
    }

    var correctTrailing: CGFloat {
        return -self * APP_WIDTH() / 375.0
    }

    var correctTop: CGFloat {
        return APP_HEIGHT() * (self / 812.0)
    }

    var correctBottom: CGFloat {
        return -APP_HEIGHT() * (self / 812.0)
    }
}

extension UIView {
    func startMoveRepeatAnimate(duration: CGFloat, amount: CGFloat) {
        let random = Array(0 ... 1).randomElement() ?? 0
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: [.autoreverse, .repeat],
            animations: {
                self.transform = CGAffineTransform(translationX: 0, y: amount * (random == 0 ? 1 : -1))
            },
            completion: nil
        )
    }
}
