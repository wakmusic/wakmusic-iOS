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

class MainTabBarViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stackContentView: UIView!
    @IBOutlet weak var stackContentViewBottomConstraint: NSLayoutConstraint!
    
    var currentIndex = 0
    
    private lazy var tabs: [TabItemView] = {
        var items = [TabItemView]()
        for _ in 0..<5 {
            items.append(TabItemView.newInstance)
        }
        return items
    }()
    
    private lazy var tabItems: [TabItem] = {
        return [
            TabItem(title: "홈",
                    offImage: DesignSystemAsset.TabBar.homeOff.image,
                    onImage: DesignSystemAsset.TabBar.homeOn.image,
                    animateImage: "Home_Tab"),
            TabItem(title: "차트",
                    offImage: DesignSystemAsset.TabBar.chartOff.image,
                    onImage: DesignSystemAsset.TabBar.chartOn.image,
                    animateImage: "Chart_Tab"),
            TabItem(title: "검색",
                    offImage: DesignSystemAsset.TabBar.searchOff.image,
                    onImage: DesignSystemAsset.TabBar.searchOn.image,
                    animateImage: "Search_Tab"),
            TabItem(title: "아티스트",
                    offImage: DesignSystemAsset.TabBar.artistOff.image,
                    onImage: DesignSystemAsset.TabBar.artistOn.image,
                    animateImage: "Artist_Tab"),
            TabItem(title: "보관함",
                    offImage: DesignSystemAsset.TabBar.storageOff.image,
                    onImage: DesignSystemAsset.TabBar.storageOn.image,
                    animateImage: "Storage_Tab")
        ]
    }()

    private lazy var viewControllers: [UIViewController] = {
        return [HomeViewController.viewController(),
                ChartViewController.viewController(),
                SearchViewController.viewController(),
                ArtistViewController.viewController(),
                StorageViewController.viewController()
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

        for (index, model) in self.tabItems.enumerated() {
            let tabView = self.tabs[index]
            model.isSelected = index == 0
            tabView.item = model
            tabView.delegate = self
            self.stackView.addArrangedSubview(tabView)
        }
        
        add(asChildViewController: viewControllers[0])
    }
    
    func updateLayout(value: CGFloat) {
        
        stackContentViewBottomConstraint.constant = -56.0 * value
        stackContentView.alpha = (1 - value)
        view.layoutIfNeeded()
    }
}

extension MainTabBarViewController: TabItemViewDelegate {
    
    func handleTap(view: TabItemView) {
        
        guard view.isSelected == false else {
            DEBUG_LOG("equal handleTap")
            return
        }
        
        //previous selected
        remove(asChildViewController: viewControllers[self.currentIndex])
        self.tabs[self.currentIndex].isSelected = false
        
        //current select
        view.isSelected = true
        let newIndex = self.tabs.firstIndex(where: { $0 === view }) ?? 0
        self.currentIndex = newIndex
        add(asChildViewController: viewControllers[newIndex])
    }
}

extension MainTabBarViewController {

    func add(asChildViewController viewController: UIViewController) {
        
        addChild(viewController)
        contentView.addSubview(viewController.view)
        
        viewController.view.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }

        viewController.didMove(toParent: self)
    }
    
    func remove(asChildViewController viewController: UIViewController) {

        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
}

extension MainTabBarViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
