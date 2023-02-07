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
import BaseFeature
import HomeFeature
import SearchFeature
import ArtistFeature
import ChartFeature
import StorageFeature

public class MainTabBarViewController: BaseViewController, ViewControllerFromStoryBoard, ContainerViewType {

    @IBOutlet weak public var contentView: UIView!

    private lazy var viewControllers: [UIViewController] = {
        return [HomeViewController.viewController().wrapNavigationController,
                ChartViewController.viewController().wrapNavigationController,
                searchComponent.makeView().wrapNavigationController,
                ArtistViewController.viewController().wrapNavigationController,
                StorageViewController.viewController().wrapNavigationController
        ]
    }()

    var previousIndex: Int?
    var selectedIndex: Int = Utility.PreferenceManager.startPage ?? 0
    var searchComponent: SearchComponent!
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }

    public static func viewController(
        searchComponent: SearchComponent
    ) -> MainTabBarViewController {
        let viewController = MainTabBarViewController.viewController(storyBoardName: "Main", bundle: Bundle.module)
        
        viewController.searchComponent = searchComponent
        
        return viewController
    }
}

extension MainTabBarViewController {

    private func configureUI() {
        let startPage: Int = Utility.PreferenceManager.startPage ?? 0
        add(asChildViewController: viewControllers[startPage])
    }
    
    func updateContent(previous: Int, current: Int) {
        
        Utility.PreferenceManager.startPage = current
        
        remove(asChildViewController: viewControllers[previous])
        add(asChildViewController: viewControllers[current])
        
        self.previousIndex = previous
        self.selectedIndex = current
    }
    
    func forceUpdateContent(for index: Int) {
        
        Utility.PreferenceManager.startPage = index

        if let previous = self.previousIndex{
            remove(asChildViewController: viewControllers[previous])
        }
        add(asChildViewController: viewControllers[index])
        
        self.previousIndex = self.selectedIndex
        self.selectedIndex = index
    }
}

extension MainTabBarViewController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
