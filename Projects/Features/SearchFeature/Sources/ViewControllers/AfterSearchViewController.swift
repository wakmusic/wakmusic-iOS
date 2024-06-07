import BaseFeature
import BaseFeatureInterface
import DesignSystem
import NVActivityIndicatorView
import Pageboy
import ReactorKit
import RxSwift
import SearchFeatureInterface
import SongsDomainInterface
import Tabman
import UIKit
import Utility

public final class AfterSearchViewController: TabmanViewController, ViewControllerFromStoryBoard, StoryboardView {
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var fakeView: UIView!
    @IBOutlet weak var indicator: NVActivityIndicatorView!

    private var songSearchResultFactory: SongSearchResultFactory!
    public var disposeBag = DisposeBag()

    private var viewControllers: [UIViewController] = [
        UIViewController(),
        UIViewController()
    ]

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.scrollToPage(.at(index: 0), animated: false)
    }

    public static func viewController(
        songSearchResultFactory: any SongSearchResultFactory,
        reactor: AfterSearchReactor
    ) -> AfterSearchViewController {
        let viewController = AfterSearchViewController.viewController(storyBoardName: "Search", bundle: Bundle.module)
        viewController.songSearchResultFactory = songSearchResultFactory
        viewController.reactor = reactor
        return viewController
    }

    deinit {
        DEBUG_LOG("❌ \(Self.self)")
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
            .filter{ !$0.isEmpty }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { owner, text in
                owner.viewControllers = [
                    owner.songSearchResultFactory.makeView(text),
                    owner.songSearchResultFactory.makeView(text)
                ]
                owner.reloadData()
            })
            .disposed(by: disposeBag)
    }

    func bindAction(reactor: AfterSearchReactor) {}

    private func configureUI() {
        self.fakeView.backgroundColor = DesignSystemAsset.BlueGrayColor.gray100.color
        self.indicator.type = .circleStrokeSpin
        self.indicator.color = DesignSystemAsset.PrimaryColor.point.color
        self.dataSource = self // dateSource
        let bar = TMBar.ButtonBar()

        // 배경색
        bar.backgroundView.style = .flat(color: .clear)

        // 간격 설정
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        bar.layout.contentMode = .fit
        bar.layout.transitionStyle = .progressive

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

extension AfterSearchViewController: PageboyViewControllerDataSource, TMBarDataSource {
    public func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        viewControllers.count
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
        #warning("구현이 끝난 후 연결")
//        let current: Int = self.currentIndex ?? 0
//        let searchContent = self.viewControllers.compactMap { $0 as? AfterSearchContentViewController }
//        guard searchContent.count > current else { return }
//        searchContent[current].scrollToTop()
    }
}
