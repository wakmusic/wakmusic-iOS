//
//  AfterLoginViewController.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/26.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem
import Pageboy
import Tabman

class AfterLoginStorageViewController: TabmanViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var editButton: UIButton!
    private var viewControllers: [UIViewController] = [UIViewController(),UIViewController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()

        // Do any additional setup after loading the view.
    }
    
    public static func viewController() -> AfterLoginStorageViewController {
        let viewController = AfterLoginStorageViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        return viewController
    }

}



extension AfterLoginStorageViewController{
    
    private func configureUI(){
        profileImageButton.setImage(DesignSystemAsset.Profile.profile0.image, for: .normal)
        
        profileLabel.text = "닉네임"
        profileLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        
        logoutButton.setImage(DesignSystemAsset.Storage.logout.image, for: .normal)
        
        requestButton.setImage(DesignSystemAsset.Storage.request.image, for: .normal)
        
        
        
        //탭바 설정
        self.dataSource = self
        let bar = TMBar.ButtonBar()
        
        
        // 배경색
       
        bar.backgroundView.style = .flat(color: colorFromRGB(0xF0F3F6))
        
        // 간격 설정
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        bar.layout.contentMode = .intrinsic
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

extension AfterLoginStorageViewController:PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        self.viewControllers.count
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        nil
    }
    
    func barItem(for bar: Tabman.TMBar, at index: Int) -> Tabman.TMBarItemable {
        
        switch index{
        case 0:
            return TMBarItem(title: "내 리스트")
        case 1:
            return TMBarItem(title: "좋아요")
        default:
            let title = "Page \(index)"
           return TMBarItem(title: title)
        }
        
    }
    
    
}
