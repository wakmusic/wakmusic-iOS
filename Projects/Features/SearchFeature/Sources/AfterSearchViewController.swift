//
//  AfterSearchContentViewController.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/01/11.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem
import Pageboy
import Tabman

class AfterSearchViewController: TabmanViewController, ViewControllerFromStoryBoard  {

    @IBOutlet weak var tabBarView: UIView!
    
    @IBOutlet weak var fakeView: UIView!
    private var viewControllers: [UIViewController] = [AfterSearchContentViewController.viewController(.all),
                                                       AfterSearchContentViewController.viewController(.song),
                                                       AfterSearchContentViewController.viewController(.artist),
                                                       AfterSearchContentViewController.viewController(.assistant)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    

    public static func viewController() -> AfterSearchViewController {
        let viewController = AfterSearchViewController.viewController(storyBoardName: "Search", bundle: Bundle.module)
        return viewController
    }

}

extension AfterSearchViewController {
    
    private func configureUI() {
        self.fakeView.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
        self.dataSource = self //dateSource
        let bar = TMBar.ButtonBar()
        
        // 배경색
        bar.backgroundView.style = .flat(color: colorFromRGB(0xF0F3F6))
        
        // 간격 설정
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        bar.layout.contentMode = .fit
        bar.layout.transitionStyle = .progressive
        
        
        // 버튼 글씨 커스텀
        bar.buttons.customize { (button) in
            button.tintColor = DesignSystemAsset.GrayColor.gray400.color
            button.selectedTintColor = DesignSystemAsset.GrayColor.gray900.color
            button.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
            button.selectedFont = DesignSystemFontFamily.Pretendard.bold.font(size: 16)
        }
        
        // indicator
        bar.indicator.weight = .custom(value: 3)
        bar.indicator.tintColor = DesignSystemAsset.PrimaryColor.point.color
        bar.indicator.overscrollBehavior = .compress
        
    
        addBar(bar, dataSource: self, at: .custom(view: tabBarView, layout: nil))
        
        
        
    }
}


extension AfterSearchViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        viewControllers.count
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        nil
    }
    
    func barItem(for bar: Tabman.TMBar, at index: Int) -> Tabman.TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "전체")
        case 1:
            return TMBarItem(title: "노래")
        case 2:
           return TMBarItem(title: "가수")
        case 3:
           return TMBarItem(title: "조교")
        default:
            let title = "Page \(index)"
           return TMBarItem(title: title)
        }
    }
    
    
}
