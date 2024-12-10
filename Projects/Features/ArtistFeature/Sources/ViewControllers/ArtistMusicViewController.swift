import ArtistDomainInterface
import DesignSystem
import LogManager
import Pageboy
import Tabman
import UIKit
import Utility

public class ArtistMusicViewController: TabmanViewController, ViewControllerFromStoryBoard {
    @IBOutlet weak var tabBarContentView: UIView!

    lazy var viewControllers: [UIViewController] = {
        let viewControllers = [
            artistMusicContentComponent.makeView(type: .new, model: model),
            artistMusicContentComponent.makeView(type: .popular, model: model),
            artistMusicContentComponent.makeView(type: .old, model: model)
        ]
        return viewControllers
    }()

    var artistMusicContentComponent: ArtistMusicContentComponent!
    var model: ArtistEntity?

    deinit {
        DEBUG_LOG("\(Self.self) Deinit")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override public func pageboyViewController(
        _ pageboyViewController: PageboyViewController,
        didScrollToPageAt index: TabmanViewController.PageIndex,
        direction: PageboyViewController.NavigationDirection,
        animated: Bool
    ) {
        LogManager.analytics(
            ArtistAnalyticsLog.clickArtistTabbarTab(
                tab: index == 0 ? "new" :
                    index == 1 ? "popular" : "old",
                artist: model?.id ?? ""
            )
        )
    }

    public static func viewController(
        model: ArtistEntity?,
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
        bar.backgroundView.style = .clear

        // 간격 설정
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        bar.layout.contentMode = .fit
        bar.layout.transitionStyle = .progressive
        bar.layout.interButtonSpacing = 0

        // 버튼 글씨 커스텀
        bar.buttons.customize { button in
            button.tintColor = DesignSystemAsset.BlueGrayColor.gray400.color
            button.selectedTintColor = DesignSystemAsset.BlueGrayColor.gray900.color
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

extension ArtistMusicViewController: @preconcurrency PageboyViewControllerDataSource, @preconcurrency TMBarDataSource {
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
