//
//  BottomTabBarViewController.swift
//  MainTabFeature
//
//  Created by KTH on 2023/01/14.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem

protocol BottomTabBarViewDelegate: AnyObject {
    func handleTapped(index previous: Int, current: Int)
}

class BottomTabBarViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var stackView: UIStackView!
    
    var currentIndex = 0
    weak var delegate: BottomTabBarViewDelegate?

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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }

    public static func viewController() -> BottomTabBarViewController {
        let viewController = BottomTabBarViewController.viewController(storyBoardName: "Main", bundle: Bundle.module)
        return viewController
    }
}

extension BottomTabBarViewController {
    
    private func configureUI() {
        
        for (index, model) in self.tabItems.enumerated() {
            let tabView = self.tabs[index]
            model.isSelected = index == 0
            tabView.item = model
            tabView.delegate = self
            self.stackView.addArrangedSubview(tabView)
        }
    }
}

extension BottomTabBarViewController: TabItemViewDelegate {
    
    func handleTap(view: TabItemView) {
        
        guard view.isSelected == false else {
            DEBUG_LOG("equal handleTap")
            return
        }
        
        //previous selected
        let previousIndex = self.currentIndex
        self.tabs[self.currentIndex].isSelected = false
        
        //current select
        view.isSelected = true
        let newIndex = self.tabs.firstIndex(where: { $0 === view }) ?? 0
        self.currentIndex = newIndex
        
        DEBUG_LOG(self.parent)
        DEBUG_LOG(self.parent?.parent)

        //delegate
        self.delegate?.handleTapped(index: previousIndex, current: newIndex)
    }
}
