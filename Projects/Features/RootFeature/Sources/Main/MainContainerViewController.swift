//
//  MainContainerViewController.swift
//  RootFeature
//
//  Created by KTH on 2023/01/02.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem

class MainContainerViewController: UIViewController, ViewControllerFromStoryBoard {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    public static func viewController() -> MainContainerViewController {
        let viewController = MainContainerViewController.viewController(storyBoardName: "Main", bundle: Bundle.module)
        return viewController
    }
}

extension MainContainerViewController {

    private func configureUI() {

        self.navigationController?.setNavigationBarHidden(true, animated: false)

        let viewController = MainTabBarController.viewController().wrapNavigationController
        self.addChild(viewController)
        viewController.didMove(toParent: self)
    }
}
