//
//  ChartViewController.swift
//  RootFeature
//
//  Created by KTH on 2023/01/01.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem

class ChartViewController: UIViewController, ViewControllerFromStoryBoard {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    public static func viewController() -> ChartViewController {
        let viewController = ChartViewController.viewController(storyBoardName: "Chart", bundle: Bundle.module)
        return viewController
    }
}
