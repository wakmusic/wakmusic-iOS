//
//  SearchViewController.swift
//  RootFeature
//
//  Created by KTH on 2023/01/02.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem
import PanModal

class SearchViewController: UIViewController, ViewControllerFromStoryBoard {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    public static func viewController() -> SearchViewController {
        let viewController = SearchViewController.viewController(storyBoardName: "Search", bundle: Bundle.module)
        return viewController
    }

    @IBAction func buttonAction(_ sender: Any) {
        let textPopupViewController = TextPopupViewController.viewController(text: "한 줄\n두 줄")
        let viewController: PanModalPresentable.LayoutType = textPopupViewController
        self.presentPanModal(viewController)
    }
}
