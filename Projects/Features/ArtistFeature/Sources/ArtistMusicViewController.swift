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
    
    private lazy var viewControllers: [UIViewController] = {
        let viewControllers = [ArtistMusicContentViewController.viewController(),
                               ArtistMusicContentViewController.viewController(),
                               ArtistMusicContentViewController.viewController()]
        return viewControllers
    }()

    deinit {
        DEBUG_LOG("\(Self.self) Deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func pageboyViewController(_ pageboyViewController: PageboyViewController,
                                        didScrollToPageAt index: TabmanViewController.PageIndex,
                                        direction: PageboyViewController.NavigationDirection,
                                        animated: Bool) {
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
