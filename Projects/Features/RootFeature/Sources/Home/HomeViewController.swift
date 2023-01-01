//
//  HomeViewController.swift
//  RootFeature
//
//  Created by KTH on 2023/01/01.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem

class HomeViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var gradationImageView: UIImageView!{
        didSet{
            gradationImageView.image = DesignSystemAsset.Home.gradationBg.image
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        DEBUG_LOG("\(Self.self) viewDidLoad")
    }

    public static func viewController() -> HomeViewController {
        let viewController = HomeViewController.viewController(storyBoardName: "Home", bundle: Bundle.module)
        return viewController
    }
}
