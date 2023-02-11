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
import DomainModule

public class ArtistMusicViewController: TabmanViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var tabBarContentView: UIView!
    
    private lazy var viewControllers: [UIViewController] = {
        let viewControllers = [
            artistMusicContentComponent.makeView(type: .new, model: model),
            artistMusicContentComponent.makeView(type: .popular, model: model),
            artistMusicContentComponent.makeView(type: .old, model: model)
        ]
        return viewControllers
    }()
    
    var artistMusicContentComponent: ArtistMusicContentComponent!
    var model: ArtistListEntity?
    
    deinit {
        DEBUG_LOG("\(Self.self) Deinit")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    public override func pageboyViewController(_ pageboyViewController: PageboyViewController,
                                               didScrollToPageAt index: TabmanViewController.PageIndex,
                                               direction: PageboyViewController.NavigationDirection,
                                               animated: Bool) {
    }

    public static func viewController(
        model: ArtistListEntity?,
        artistMusicContentComponent: ArtistMusicContentComponent
    ) -> ArtistMusicViewController {
        let viewController = ArtistMusicViewController.viewController(storyBoardName: "Artist", bundle: Bundle.module)
        viewController.model = model
        viewController.artistMusicContentComponent = artistMusicContentComponent
        return viewController
    }
}

extension ArtistMusicViewController {
    
    private func configureUI() {
        
        self.dataSource = self
        let bar = TMBar.ButtonBar()
        
        // 배경색
        bar.backgroundView.style = .flat(color: DesignSystemAsset.GrayColor.gray100.color)
        
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
        bar.indicator.weight = .custom(value: 2)
        bar.indicator.tintColor = DesignSystemAsset.PrimaryColor.point.color
        bar.indicator.overscrollBehavior = .compress

        addBar(bar, dataSource: self, at: .custom(view: tabBarContentView, layout: nil))
        bar.layer.addBorder([.bottom], color:DesignSystemAsset.GrayColor.gray300.color.withAlphaComponent(0.4), height: 1)
    }
}

extension ArtistMusicViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    public func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
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

    public func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    public func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    public func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
