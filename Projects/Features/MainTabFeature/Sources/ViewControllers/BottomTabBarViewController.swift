import DesignSystem
import LogManager
import RxSwift
import UIKit
import Utility

protocol BottomTabBarViewDelegate: AnyObject {
    func handleTapped(index previous: Int, current: Int)
    func equalHandleTapped(index current: Int)
}

public final class BottomTabBarViewController: UIViewController, ViewControllerFromStoryBoard {
    @IBOutlet weak var stackView: UIStackView!

    private var currentIndex = Utility.PreferenceManager.startPage ?? 0
    weak var delegate: BottomTabBarViewDelegate?

    private lazy var tabs: [TabItemView] = {
        var items = [TabItemView]()
        for _ in 0 ..< 5 {
            items.append(TabItemView.newInstance)
        }
        return items
    }()

    private lazy var tabItems: [TabItem] = {
        return [
            TabItem(
                title: "홈",
                offImage: DesignSystemAsset.TabBar.homeOff.image,
                onImage: DesignSystemAsset.TabBar.homeOn.image,
                animateImage: "Home_Tab",
                analyticsTabbarType: .home
            ),
            TabItem(
                title: "검색",
                offImage: DesignSystemAsset.TabBar.searchOff.image,
                onImage: DesignSystemAsset.TabBar.searchOn.image,
                animateImage: "Search_Tab",
                analyticsTabbarType: .search
            ),
            TabItem(
                title: "아티스트",
                offImage: DesignSystemAsset.TabBar.artistOff.image,
                onImage: DesignSystemAsset.TabBar.artistOn.image,
                animateImage: "Artist_Tab",
                analyticsTabbarType: .artist
            ),
            TabItem(
                title: "보관함",
                offImage: DesignSystemAsset.TabBar.storageOff.image,
                onImage: DesignSystemAsset.TabBar.storageOn.image,
                animateImage: "Storage_Tab",
                analyticsTabbarType: .storage
            ),
            TabItem(
                title: "내정보",
                offImage: DesignSystemAsset.TabBar.myinfoOff.image,
                onImage: DesignSystemAsset.TabBar.myinfoOn.image,
                animateImage: "MyInfo_Tab",
                analyticsTabbarType: .mypage
            )
        ]
    }()

    private let disposeBag = DisposeBag()

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    public static func viewController() -> BottomTabBarViewController {
        let viewController = BottomTabBarViewController.viewController(storyBoardName: "Main", bundle: Bundle.module)
        return viewController
    }
}

private extension BottomTabBarViewController {
    func configureUI() {
        let startPage: Int = Utility.PreferenceManager.startPage ?? 0
        LogManager.printDebug("startPage: \(startPage)")

        for (index, model) in self.tabItems.enumerated() {
            let tabView = self.tabs[index]
            model.isSelected = (index == startPage)
            tabView.item = model
            tabView.delegate = self
            self.stackView.addArrangedSubview(tabView)
        }
    }
}

extension BottomTabBarViewController: TabItemViewDelegate {
    func handleTap(view: TabItemView) {
        guard view.isSelected == false else {
            self.delegate?.equalHandleTapped(index: self.currentIndex)
            return
        }

        // previous selected
        let previousIndex = self.currentIndex
        self.tabs[self.currentIndex].isSelected = false

        // current select
        view.isSelected = true
        let newIndex = self.tabs.firstIndex(where: { $0 === view }) ?? 0
        self.currentIndex = newIndex

        // delegate
        self.delegate?.handleTapped(index: previousIndex, current: newIndex)
    }
}
