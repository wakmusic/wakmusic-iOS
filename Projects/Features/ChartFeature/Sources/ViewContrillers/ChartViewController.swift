import CommonFeature
import DesignSystem
import Pageboy
import Tabman
import UIKit
import Utility

public final class ChartViewController: TabmanViewController, ViewControllerFromStoryBoard {
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

    private let tabBarContentView = UIView()

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    public static func viewController(chartContentComponent: ChartContentComponent) -> ChartViewController {
        let viewController = ChartViewController.viewController(storyBoardName: "Chart", bundle: Bundle.module)
        viewController.chartContentComponent = chartContentComponent
        return viewController
    }
}

extension ChartViewController {
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

        view.addSubview(tabBarContentView)
        tabBarContentView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(40)
        }

        addBar(bar, dataSource: self, at: .custom(view: self.tabBarContentView, layout: nil))
        bar.layer.addBorder(
            [.bottom],
            color: DesignSystemAsset.GrayColor.gray300.color.withAlphaComponent(0.4),
            height: 1
        )
    }
}

extension ChartViewController: PageboyViewControllerDataSource, TMBarDataSource {
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

public extension ChartViewController {
    func equalHandleTapped() {
        let viewControllersCount: Int = self.navigationController?.viewControllers.count ?? 0
        if viewControllersCount > 1 {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            let current: Int = self.currentIndex ?? 0
            let chartContent = self.viewControllers.compactMap { $0 }
            guard chartContent.count > current else { return }
            chartContent[current].scrollToTop()
        }
    }
}
