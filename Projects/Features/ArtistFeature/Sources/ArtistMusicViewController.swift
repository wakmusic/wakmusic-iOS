//
//  ArtistMusicViewController.swift
//  ArtistFeature
//
//  Created by KTH on 2023/01/07.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem
import Pageboy
import Tabman

class ArtistMusicViewController: TabmanViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var tabBarContentView: UIView!
    
    private var viewControllers: [UIViewController] = [ArtistMusicContentViewController.viewController(),
                                                       ArtistMusicContentViewController.viewController(),
                                                       ArtistMusicContentViewController.viewController()]

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    public static func viewController() -> ArtistMusicViewController {
        let viewController = ArtistMusicViewController.viewController(storyBoardName: "Artist", bundle: Bundle.module)
        return viewController
    }
}

extension ArtistMusicViewController {
    
    private func configureUI() {
        
        self.dataSource = self
        let bar = TMBar.ButtonBar()
        
        // 배경 회색 -> 하얀색
        bar.backgroundView.style = .blur(style: .light)
        
        // 간격 설정
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        bar.layout.contentMode = .fit
        bar.layout.transitionStyle = .snap
        
        // 버튼 글씨 커스텀
        bar.buttons.customize { (button) in
            button.tintColor = colorFromRGB(0x98A2B3)
            button.selectedTintColor = colorFromRGB(0x101828)
            button.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            button.selectedFont = UIFont.systemFont(ofSize: 16, weight: .bold)
        }
        
        // indicator
        bar.indicator.weight = .custom(value: 2)
        bar.indicator.tintColor = DesignSystemAsset.PrimaryColor.point.color
        bar.indicator.overscrollBehavior = .compress
        
        addBar(bar, dataSource: self, at: .custom(view: tabBarContentView, layout: nil))
    }
}

extension ArtistMusicViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "최신순")
        case 1:
            return TMBarItem(title: "인기순")
        case 2:
           return TMBarItem(title: "과거순")
        default:
            let title = "Page \(index)"
           return TMBarItem(title: title)
        }
    }

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
