import CreditSongListFeatureInterface
import DesignSystem
import Pageboy
import SnapKit
import Tabman
import UIKit
import Utility

final class CreditSongListTabViewController: TabmanViewController {
    private let tabContainerView = UIView()

    private let sortTypes = CreditSongSortType.allCases

    private let viewControllers: [UIViewController]

    private var tabUnderlineLayer: CALayer?

    init(
        workerName: String,
        creditSongListTabItemFactory: any CreditSongListTabItemFactory
    ) {
        self.viewControllers = CreditSongSortType.allCases.map {
            creditSongListTabItemFactory.makeViewController(workerName: workerName, sortType: $0)
        }
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        addView()
        setLayout()
        configureUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if tabUnderlineLayer == nil {
            let underlineLayer = CALayer()
            underlineLayer.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray200.color.cgColor
            underlineLayer.frame = CGRect(
                x: 0,
                y: tabContainerView.frame.size.height - 1,
                width: tabContainerView.frame.size.width,
                height: 1
            )
            tabContainerView.layer.addSublayer(underlineLayer)
        }
    }
}

private extension CreditSongListTabViewController {
    func addView() {
        view.addSubviews(tabContainerView)
    }

    func setLayout() {
        tabContainerView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(CGFloat.tabbarHeight)
        }
    }

    func configureUI() {
        let bar = TMBar.ButtonBar()

        bar.backgroundView.style = .clear

        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        bar.layout.contentMode = .fit
        bar.layout.transitionStyle = .progressive
        bar.layout.interButtonSpacing = 0

        bar.buttons.customize { button in
            button.tintColor = DesignSystemAsset.BlueGrayColor.blueGray400.color
            button.selectedTintColor = DesignSystemAsset.BlueGrayColor.blueGray900.color
            button.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
            button.selectedFont = DesignSystemFontFamily.Pretendard.bold.font(size: 16)
        }

        bar.indicator.weight = .custom(value: 2)
        bar.indicator.tintColor = DesignSystemAsset.PrimaryColorV2.point.color
        bar.indicator.overscrollBehavior = .compress

        addBar(bar, dataSource: self, at: .custom(view: tabContainerView, layout: nil))
        bar.layer.zPosition = 1
    }
}

extension CreditSongListTabViewController: @preconcurrency PageboyViewControllerDataSource {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        sortTypes.count
    }

    func viewController(
        for pageboyViewController: PageboyViewController,
        at index: PageboyViewController.PageIndex
    ) -> UIViewController? {
        viewControllers[safe: index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        .first
    }
}

extension CreditSongListTabViewController: @preconcurrency TMBarDataSource {
    func barItem(for bar: any TMBar, at index: Int) -> any TMBarItemable {
        guard let sortItem = sortTypes[safe: index] else { return TMBarItem(title: "") }

        return TMBarItem(title: sortItem.display)
    }
}

private extension CGFloat {
    static let tabbarHeight: CGFloat = 36
}
