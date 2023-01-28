//
//  MainTabBarViewController.swift
//  MainTabFeature
//
//  Created by KTH on 2023/01/13.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem
import SnapKit
import HomeFeature
import SearchFeature
import ArtistFeature
import ChartFeature
import StorageFeature

class MainTabBarViewController: UIViewController, ViewControllerFromStoryBoard, ContainerViewType {

    @IBOutlet weak var contentView: UIView!

    private lazy var viewControllers: [UIViewController] = {
        return [HomeViewController.viewController().wrapNavigationController,
                ChartViewController.viewController().wrapNavigationController,
                SearchViewController.viewController().wrapNavigationController,
                ArtistViewController.viewController().wrapNavigationController,
                StorageViewController.viewController().wrapNavigationController
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }

    public static func viewController() -> MainTabBarViewController {
        let viewController = MainTabBarViewController.viewController(storyBoardName: "Main", bundle: Bundle.module)
        return viewController
    }
}

extension MainTabBarViewController {
    
    private func configureUI() {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        add(asChildViewController: viewControllers[0])
    }
    
    func updateContent(previous: Int, current: Int) {
        
        remove(asChildViewController: viewControllers[previous])
        add(asChildViewController: viewControllers[current])
    }
}

extension MainTabBarViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
