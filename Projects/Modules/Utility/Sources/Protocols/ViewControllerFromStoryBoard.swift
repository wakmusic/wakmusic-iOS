//
//  ViewControllerFromStoryBoard.swift
//  Utility
//
//  Created by KTH on 2023/01/01.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import UIKit

public protocol ViewControllerFromStoryBoard {}

public extension ViewControllerFromStoryBoard where Self: UIViewController {

    static func viewController(storyBoardName: String, bundle: Bundle) -> Self {
        guard let viewController = UIStoryboard(name: storyBoardName, bundle: bundle)
            .instantiateViewController(withIdentifier: String(describing: Self.self)) as? Self
            else { return Self() }
        return viewController
    }
}
