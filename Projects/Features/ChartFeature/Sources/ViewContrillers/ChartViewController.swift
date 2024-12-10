import BaseFeature
import DesignSystem
import LogManager
import Pageboy
import Tabman
import UIKit
import Utility

public final class ChartViewController: TabmanViewController, ViewControllerFromStoryBoard {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var naviTitleLabel: UILabel!
    @IBOutlet weak var tabBarContentView: UIView!

    private var chartContentComponent: ChartContentComponent?
    private lazy var viewControllers: [ChartContentViewController?] = {
        let viewControllers = [
            chartContentComponent?.makeView(type: .hourly),
            chartContentComponent?.makeView(type: .daily),
            chartContentComponent?.makeView(type: .weekly),
            chartContentComponent?.makeView(type: .monthly),
            chartContentComponent?.makeView(type: .total)
        ]
        return viewControllers
    }()

    deinit { LogManager.printDebug("❌ \(Self.self) Deinit") }

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let log = CommonAnalyticsLog.viewPage(pageName: .chart)
        LogManager.analytics(log)
    }

    override public func pageboyViewController(
        _ pageboyViewController: PageboyViewController,
        didScrollToPageAt index: TabmanViewController.PageIndex,
        direction: PageboyViewController.NavigationDirection,
        animated: Bool
    ) {
        let chartType = ChartAnalyticsLog.ChartType.allCases[safe: index] ?? .hourly
        let log = ChartAnalyticsLog.selectChartType(type: chartType)
        LogManager.analytics(log)

        super.pageboyViewController(
            pageboyViewController,
            didScrollToPageAt: index,
            direction: direction,
            animated: animated
        )
    }

    public static func viewController(chartContentComponent: ChartContentComponent) -> ChartViewController {
        let viewController = ChartViewController.viewController(
            storyBoardName: "Chart",
            bundle: ChartFeatureResources.bundle
        )
        viewController.chartContentComponent = chartContentComponent
        return viewController
    }

    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

private extension ChartViewController {
    func configureUI() {
        backButton.setImage(DesignSystemAsset.Navigation.back.image, for: .normal)
        naviTitleLabel.text = "왁뮤차트 TOP100"
        naviTitleLabel.textColor = DesignSystemAsset.BlueGrayColor.blueGray900.color
        naviTitleLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        naviTitleLabel.setTextWithAttributes(alignment: .center)

        self.dataSource = self
        let bar = TMBar.ButtonBar()

        // 배경색
        bar.backgroundView.style = .flat(color: DesignSystemAsset.BlueGrayColor.gray100.color)

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

        addBar(bar, dataSource: self, at: .custom(view: self.tabBarContentView, layout: nil))
        bar.layer.addBorder(
            [.bottom],
            color: DesignSystemAsset.BlueGrayColor.gray300.color.withAlphaComponent(0.4),
            height: 1
        )
    }
}

extension ChartViewController: @preconcurrency PageboyViewControllerDataSource, @preconcurrency TMBarDataSource {
    public func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "시간순")
        case 1:
            return TMBarItem(title: "일간순")
        case 2:
            return TMBarItem(title: "주간순")
        case 3:
            return TMBarItem(title: "월간순")
        case 4:
            return TMBarItem(title: "누적순")
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
