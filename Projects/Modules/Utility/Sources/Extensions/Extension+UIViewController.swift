//
//  Extension+UIViewController.swift
//  Utility
//
//  Created by KTH on 2023/01/02.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

public extension UIViewController {

    var wrapNavigationController: UINavigationController {
        return UINavigationController(rootViewController: self)
    }
}
