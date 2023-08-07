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
import RxSwift

protocol BottomTabBarViewDelegate: AnyObject {
    func handleTapped(index previous: Int, current: Int)
    func equalHandleTapped(index current: Int)
}

public class BottomTabBarViewController: UIViewController, ViewControllerFromStoryBoard {
    @IBOutlet weak var stackView: UIStackView!
    
    var currentIndex = Utility.PreferenceManager.startPage ?? 0
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
    
    var disposeBag = DisposeBag()

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindNotification()
    }

    public static func viewController() -> BottomTabBarViewController {
        let viewController = BottomTabBarViewController.viewController(storyBoardName: "Main", bundle: Bundle.module)
        return viewController
    }
}

extension BottomTabBarViewController {
    private func configureUI() {
        let startPage: Int = Utility.PreferenceManager.startPage ?? 0
        DEBUG_LOG("startPage: \(startPage)")

        for (index, model) in self.tabItems.enumerated() {
            let tabView = self.tabs[index]
            model.isSelected = (index == startPage)
            tabView.item = model
            tabView.delegate = self
            self.stackView.addArrangedSubview(tabView)
        }
    }
    
    private func bindNotification() {
        NotificationCenter.default.rx
            .notification(.movedTab)
            .subscribe(onNext: { [weak self] (notification) in
                guard
                    let `self` = self,
                    let index = notification.object as? Int,
                    self.tabs.count > index
                else { return }
                
                self.handleTap(view: self.tabs[index])
            }).disposed(by: disposeBag)
    }
}

extension BottomTabBarViewController: TabItemViewDelegate {
    func handleTap(view: TabItemView) {
        guard view.isSelected == false else {
            self.delegate?.equalHandleTapped(index: self.currentIndex)
            return
        }
        
        //previous selected
        let previousIndex = self.currentIndex
        self.tabs[self.currentIndex].isSelected = false
        
        //current select
        view.isSelected = true
        let newIndex = self.tabs.firstIndex(where: { $0 === view }) ?? 0
        self.currentIndex = newIndex

        //delegate
        self.delegate?.handleTapped(index: previousIndex, current: newIndex)
    }
}
