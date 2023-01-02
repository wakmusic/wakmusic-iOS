//
//  PlayerViewController.swift
//  RootFeatureTests
//
//  Created by KTH on 2023/01/02.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem

class PlayerViewController: UIViewController, ViewControllerFromStoryBoard {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    public static func viewController() -> PlayerViewController {
        let viewController = PlayerViewController.viewController(storyBoardName: "Player", bundle: Bundle.module)
        return viewController
    }
}
