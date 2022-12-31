//
//  IntroViewController.swift
//  RootFeature
//
//  Created by KTH on 2022/12/31.
//  Copyright © 2022 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem

public class IntroViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var logoImageView: UIImageView!

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    public static func viewController() -> IntroViewController {
        let viewController = IntroViewController.viewController(storyBoardName: "Intro", bundle: Bundle.module)
        return viewController
    }
}

extension IntroViewController {

    private func configureUI() {
        logoImageView.image = DesignSystemAsset.Logo.splash.image
    }
}
