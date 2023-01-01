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

open class IntroViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var logoImageView: UIImageView!

    open override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()

        // Intro 화면에서는 앱에 대한 기본 정보를 받아오는 일을 보통 하는데, 없어서 딜레이 조금 주고 뭔가 하는척 해봤습니다.
        self.perform(#selector(self.showTabBar), with: nil, afterDelay: 1.0)
    }

    public static func viewController() -> IntroViewController {
        let viewController = IntroViewController.viewController(storyBoardName: "Intro", bundle: Bundle.module)
        return viewController
    }
}

extension IntroViewController {

    @objc
    private func showTabBar() {
        let viewController = MainTabBarController.viewController()
        self.navigationController?.pushViewController(viewController, animated: false)
    }

    private func configureUI() {
        logoImageView.image = DesignSystemAsset.Logo.splash.image
    }
}
