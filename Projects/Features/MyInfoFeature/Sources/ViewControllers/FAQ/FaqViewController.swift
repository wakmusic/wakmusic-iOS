import DesignSystem
import LogManager
import MyInfoFeatureInterface
import NVActivityIndicatorView
import Pageboy
import RxSwift
import Tabman
import UIKit
import Utility

public final class FaqViewController: TabmanViewController, ViewControllerFromStoryBoard {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!

    @IBAction func pressBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindRx()
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil // 스와이프로 뒤로가기
    }

    var disposeBag = DisposeBag()
    var viewModel: FaqViewModel!
    var faqContentFactory: FaqContentFactory!
    lazy var input = FaqViewModel.Input()
    lazy var output = viewModel.transform(from: input)

    var viewControllers: [UIViewController] = []

    public static func viewController(
        viewModel: FaqViewModel,
        faqContentFactory: FaqContentFactory
    ) -> FaqViewController {
        let viewController = FaqViewController.viewController(storyBoardName: "Faq", bundle: Bundle.module)
        viewController.viewModel = viewModel
        viewController.faqContentFactory = faqContentFactory
        return viewController
    }

    override public func pageboyViewController(
        _ pageboyViewController: PageboyViewController,
        didScrollToPageAt index: TabmanViewController.PageIndex,
        direction: PageboyViewController.NavigationDirection,
        animated: Bool
    ) {
        super.pageboyViewController(
            pageboyViewController,
            didScrollToPageAt: index,
            direction: direction,
            animated: animated
        )

        let titles = output.dataSource.value.0
        if let selectedTitle = titles[safe: index]?.trimmingCharacters(in: .whitespaces) {
            LogManager.analytics(FAQAnalyticsLog.selectFaqCategory(category: selectedTitle))
        }
    }
}

extension FaqViewController {
    private func configureUI() {
        self.backButton.setImage(DesignSystemAsset.Navigation.back.image, for: .normal)
        self.titleLabel.font = .setFont(.t5(weight: .medium))
        self.titleLabel.setTextWithAttributes(
            lineHeight: UIFont.WMFontSystem.t5(weight: .medium).lineHeight,
            kernValue: -0.5
        )
        self.activityIndicator.type = .circleStrokeSpin
        self.activityIndicator.color = DesignSystemAsset.PrimaryColor.point.color
        self.activityIndicator.startAnimating()

        // 탭바 설정
        self.dataSource = self
        let bar = TMBar.ButtonBar()

        // 배경색
        bar.backgroundView.style = .flat(color: colorFromRGB(0xF0F3F6))

        // 간격 설정
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        bar.layout.contentMode = .intrinsic
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
        addBar(bar, dataSource: self, at: .custom(view: tabBarView, layout: nil))

        // 회색 구분선 추가
        bar.layer.addBorder(
            [.bottom],
            color: DesignSystemAsset.GrayColor.gray300.color.withAlphaComponent(0.4),
            height: 1
        )
    }

    func bindRx() {
        output.dataSource
            .skip(1)
            .do(onNext: { [weak self] _, _ in
                self?.activityIndicator.stopAnimating()
            })
            .subscribe { [weak self] categories, qna in
                guard let self = self else { return }
                guard let factory = self.faqContentFactory else { return }

                self.viewControllers = categories.enumerated().map { i, c in
                    if i == 0 {
                        return factory.makeView(dataSource: qna)
                    } else {
                        return factory.makeView(dataSource: qna.filter {
                            $0.category.replacingOccurrences(of: " ", with: "") == c
                                .replacingOccurrences(of: " ", with: "")
                        })
                    }
                }
                self.reloadData()
            }.disposed(by: disposeBag)
    }
}

extension FaqViewController: @preconcurrency PageboyViewControllerDataSource, @preconcurrency TMBarDataSource {
    public func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        LogManager.printDebug(self.viewControllers.count)
        return self.viewControllers.count
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
        return TMBarItem(title: output.dataSource.value.0[index])
    }
}
