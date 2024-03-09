//
//  Extension+UIActivityIndicatorView.swift
//  Utility
//
//  Created by KTH on 2023/04/04.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import UIKit

public extension UIActivityIndicatorView {
    func stopOnMainThread() {
        DispatchQueue.main.async {
            self.stopAnimating()
        }
    }
}
