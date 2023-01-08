import UIKit
import Utility
import DesignSystem
import HomeFeature
import SearchFeature
import ArtistFeature
import ChartFeature
import StorageFeature

class MainTabBarController: UITabBarController, ViewControllerFromStoryBoard {

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

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let barItemView = item.value(forKey: "view") as? UIView else { return }
        barItemView.animateSizeDownToUp(timeInterval: 0.3)
    }

    public static func viewController() -> MainTabBarController {
        let viewController = MainTabBarController.viewController(storyBoardName: "Main", bundle: Bundle.module)
        return viewController
    }
}

extension MainTabBarController {

    private func configureUI() {

        self.navigationController?.setNavigationBarHidden(true, animated: false)

        self.viewControllers = [
            HomeViewController.viewController(),
            ChartViewController.viewController(),
            SearchViewController.viewController(),
            ArtistViewController.viewController(),
            StorageViewController.viewController()
        ]

        let topLineColor: UIColor = colorFromRGB(0xf2f4f7)
        let normalColor: UIColor = colorFromRGB(0x98A2B3)
        let selectedColor: UIColor = colorFromRGB(0x101828)

        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = .white
            appearance.shadowImage = UIImage.tabBarTopLine(color: topLineColor)

            setTabBarItemColors(appearance.stackedLayoutAppearance)
            setTabBarItemColors(appearance.inlineLayoutAppearance)
            setTabBarItemColors(appearance.compactInlineLayoutAppearance)

            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance

        } else {
            UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: normalColor], for: .normal)
            UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: selectedColor], for: .selected)
            UITabBar.appearance().shadowImage = UIImage.tabBarTopLine(color: topLineColor)
        }

        self.tabBar.backgroundColor = .white
        self.tabBar.isTranslucent = false
        self.tabBar.items?.enumerated().forEach({ (index, item) in
            switch index {
            case 0:
                item.title = "홈"
                item.image = DesignSystemAsset.TabBar.homeOff.image.withRenderingMode(.alwaysOriginal)
                item.selectedImage = DesignSystemAsset.TabBar.homeOn.image.withRenderingMode(.alwaysOriginal)

            case 1:
                item.title = "차트"
                item.image = DesignSystemAsset.TabBar.chartOff.image.withRenderingMode(.alwaysOriginal)
                item.selectedImage = DesignSystemAsset.TabBar.chartOn.image.withRenderingMode(.alwaysOriginal)

            case 2:
                item.title = "검색"
                item.image = DesignSystemAsset.TabBar.searchOff.image.withRenderingMode(.alwaysOriginal)
                item.selectedImage = DesignSystemAsset.TabBar.searchOn.image.withRenderingMode(.alwaysOriginal)

            case 3:
                item.title = "아티스트"
                item.image = DesignSystemAsset.TabBar.artistOff.image.withRenderingMode(.alwaysOriginal)
                item.selectedImage = DesignSystemAsset.TabBar.artistOn.image.withRenderingMode(.alwaysOriginal)

            case 4:
                item.title = "보관함"
                item.image = DesignSystemAsset.TabBar.storageOff.image.withRenderingMode(.alwaysOriginal)
                item.selectedImage = DesignSystemAsset.TabBar.storageOn.image.withRenderingMode(.alwaysOriginal)

            default: return
            }
        })
    }

    private func setTabBarItemColors(_ itemAppearance: UITabBarItemAppearance) {
        itemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: colorFromRGB(0x98A2B3)]
        itemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: colorFromRGB(0x101828)]
    }
}

extension MainTabBarController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
