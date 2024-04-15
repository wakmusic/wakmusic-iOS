//
//  NewSongsViewController.swift
//  CommonFeature
//
//  Created by KTH on 2023/11/15.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DesignSystem
import Pageboy
import SongsDomainInterface
import Tabman
import UIKit
import Utility

public class NewSongsViewController: TabmanViewController, ViewControllerFromStoryBoard {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var tabBarContentView: UIView!

    private var newSongsContentComponent: NewSongsContentComponent!
    private lazy var viewControllers: [NewSongsContentViewController] = {
        let viewControllers = NewSongGroupType.allCases.map {
            self.newSongsContentComponent.makeView(type: $0)
        }
        return viewControllers
    }()

    deinit { DEBUG_LOG("❌ \(Self.self) Deinit") }

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configurePage()
    }

    public static func viewController(
        newSongsContentComponent: NewSongsContentComponent
    ) -> NewSongsViewController {
        let viewController = NewSongsViewController.viewController(storyBoardName: "Home", bundle: Bundle.module)
        viewController.newSongsContentComponent = newSongsContentComponent
        return viewController
    }

    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension NewSongsViewController {
    private func configureUI() {
        self.view.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
        self.backButton.setImage(DesignSystemAsset.Navigation.back.image, for: .normal)
        self.navigationTitleLabel.text = "최신 음악"
        self.navigationTitleLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        self.navigationTitleLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        self.navigationTitleLabel.setTextWithAttributes(kernValue: -0.5)
    }

    private func configurePage() {
        self.dataSource = self
        let bar = TMBar.ButtonBar()

        // 배경색
        bar.backgroundView.style = .clear

        // 간격 설정
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        bar.layout.contentMode = .fit
        bar.layout.transitionStyle = .progressive

        // 버튼 글씨 커스텀
        bar.buttons.customize { button in
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
    }
}

extension NewSongsViewController: PageboyViewControllerDataSource, TMBarDataSource {
    public func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: NewSongGroupType.all.display)
        case 1:
            return TMBarItem(title: NewSongGroupType.woowakgood.display)
        case 2:
            return TMBarItem(title: NewSongGroupType.isedol.display)
        case 3:
            return TMBarItem(title: NewSongGroupType.gomem.display)
        case 4:
            return TMBarItem(title: NewSongGroupType.academy.display)
        default:
            let title = "Page \(index)"
            return TMBarItem(title: title)
        }
    }

    public func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }

    public func viewController(
        for pageboyViewController: PageboyViewController,
        at index: PageboyViewController.PageIndex
    ) -> UIViewController? {
        return viewControllers[index]
    }

    public func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
