import BaseFeature
import BaseFeatureInterface
import DesignSystem
import LogManager
import NVActivityIndicatorView
import Pageboy
import ReactorKit
import RxSwift
import SearchFeatureInterface
import SongsDomainInterface
import Tabman
import UIKit
import Utility

public final class AfterSearchViewController: TabmanViewController, ViewControllerFromStoryBoard,
    @preconcurrency StoryboardView {
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var fakeView: UIView!
    @IBOutlet weak var indicator: NVActivityIndicatorView!

    private var songSearchResultFactory: SongSearchResultFactory!
    private var listSearchResultFactory: ListSearchResultFactory!
    private var searchGlobalScrollState: SearchGlobalScrollProtocol!
    public var disposeBag = DisposeBag()

    private var viewControllers: [UIViewController] = [
        UIViewController(),
        UIViewController()
    ]

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    public static func viewController(
        songSearchResultFactory: SongSearchResultFactory,
        listSearchResultFactory: ListSearchResultFactory,
        searchGlobalScrollState: any SearchGlobalScrollProtocol,
        reactor: AfterSearchReactor
    ) -> AfterSearchViewController {
        let viewController = AfterSearchViewController.viewController(storyBoardName: "Search", bundle: Bundle.module)
        viewController.songSearchResultFactory = songSearchResultFactory
        viewController.listSearchResultFactory = listSearchResultFactory
        viewController.searchGlobalScrollState = searchGlobalScrollState
        viewController.reactor = reactor
        return viewController
    }

    override public func pageboyViewController(
        _ pageboyViewController: PageboyViewController,
        didScrollToPageAt index: TabmanViewController.PageIndex,
        direction: PageboyViewController.NavigationDirection,
        animated: Bool
    ) {
        searchGlobalScrollState.expand()
    }

    deinit {
        LogManager.printDebug("❌ \(Self.self)")
    }

    public func bind(reactor: AfterSearchReactor) {
        bindState(reacotr: reactor)
        bindAction(reactor: reactor)
    }
}

extension AfterSearchViewController {
    func bindState(reacotr: AfterSearchReactor) {
        let currentState = reacotr.state.share()

        currentState.map(\.text)
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { owner, text in
                owner.viewControllers = [
                    owner.songSearchResultFactory.makeView(text),
                    owner.listSearchResultFactory.makeView(text)
                ]
                owner.reloadData()
            })
            .disposed(by: disposeBag)
    }

    func bindAction(reactor: AfterSearchReactor) {}

    private func configureUI() {
        self.fakeView.backgroundColor = DesignSystemAsset.BlueGrayColor.gray100.color
        self.indicator.type = .circleStrokeSpin
        self.indicator.color = DesignSystemAsset.PrimaryColorV2.point.color
        self.dataSource = self // dateSource
        let bar = TMBar.ButtonBar()

        // 배경색
        bar.backgroundView.style = .flat(color: .clear)

        // 간격 설정
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        bar.layout.contentMode = .fit
        bar.layout.transitionStyle = .progressive
        bar.layout.interButtonSpacing = 0

        // 버튼 글씨 커스텀
        bar.buttons.customize { button in
            button.tintColor = DesignSystemAsset.BlueGrayColor.gray400.color
            button.selectedTintColor = DesignSystemAsset.BlueGrayColor.gray900.color
            button.font = .setFont(.t5(weight: .medium))
            button.selectedFont = DesignSystemFontFamily.Pretendard.bold.font(size: 16)
        }

        // indicator
        bar.indicator.weight = .custom(value: 2)
        bar.indicator.tintColor = DesignSystemAsset.PrimaryColorV2.point.color
        bar.indicator.overscrollBehavior = .compress
        addBar(bar, dataSource: self, at: .custom(view: tabBarView, layout: nil))
        bar.layer.addBorder(
            [.bottom],
            color: DesignSystemAsset.BlueGrayColor.gray300.color.withAlphaComponent(0.4),
            height: 1
        )
    }
}

extension AfterSearchViewController: @preconcurrency PageboyViewControllerDataSource, @preconcurrency TMBarDataSource {
    public func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        2
    }

    public func viewController(
        for pageboyViewController: Pageboy.PageboyViewController,
        at index: Pageboy.PageboyViewController.PageIndex
    ) -> UIViewController? {
        viewControllers[index]
    }

    public func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController
        .Page? {
        nil
    }

    public func barItem(for bar: Tabman.TMBar, at index: Int) -> Tabman.TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "노래")
        case 1:
            return TMBarItem(title: "리스트")
        default:
            let title = "Page \(index)"
            return TMBarItem(title: title)
        }
    }
}

extension AfterSearchViewController {
    func scrollToTop() {
        let current: Int = self.currentIndex ?? 0

        searchGlobalScrollState.scrollToTop(page: current == 0 ? .song : .list)
    }
}
