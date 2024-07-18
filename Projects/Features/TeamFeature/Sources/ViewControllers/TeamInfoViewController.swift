import DesignSystem
import Foundation
import LogManager
import RxCocoa
import RxSwift
import SnapKit
import TeamDomainInterface
import TeamFeatureInterface
import Then
import UIKit
import Utility
import Pageboy
import Tabman

public final class TeamInfoViewController: TabmanViewController {
    private let navigationbarView = WMNavigationBarView()

    private let backButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Navigation.back.image, for: .normal)
    }

    private let tabContentView = UIView()
    private let singleLineLabel = UILabel().then {
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.gray300.color.withAlphaComponent(0.4)
    }

    private lazy var viewControllers: [UIViewController] = {
        let viewControllers = [
            TeamInfoContentViewController(),
            TeamInfoContentViewController()
        ]
        return viewControllers
    }()

    private let viewModel: TeamInfoViewModel
    lazy var input = TeamInfoViewModel.Input()
    lazy var output = viewModel.transform(from: input)
    private let disposeBag = DisposeBag()

    deinit {
        LogManager.printDebug("❌:: \(Self.self) deinit")
    }

    public init(
        viewModel: TeamInfoViewModel
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("\(Self.self) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setLayout()
        configureUI()
        configureTab()
        outputBind()
        inputBind()
    }
}

private extension TeamInfoViewController {
    func outputBind() {}

    func inputBind() {
        backButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

private extension TeamInfoViewController {
    func addSubviews() {
        view.addSubviews(navigationbarView, tabContentView)
        tabContentView.addSubview(singleLineLabel)
        navigationbarView.setLeftViews([backButton])
        navigationbarView.setTitle("팀 소개", textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color)
    }

    func setLayout() {
        navigationbarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(48)
        }

        tabContentView.snp.makeConstraints {
            $0.top.equalTo(navigationbarView.snp.bottom).offset(16+1.71)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(36-1.71)
        }

        singleLineLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
    }

    func configureUI() {
        view.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray100.color
    }
}

private extension TeamInfoViewController {
    func configureTab() {
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
            button.tintColor = DesignSystemAsset.BlueGrayColor.gray400.color
            button.selectedTintColor = DesignSystemAsset.BlueGrayColor.gray900.color
            button.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
            button.selectedFont = DesignSystemFontFamily.Pretendard.bold.font(size: 16)
        }

        // indicator
        bar.indicator.weight = .custom(value: 1.71)
        bar.indicator.tintColor = DesignSystemAsset.PrimaryColor.point.color
        bar.indicator.overscrollBehavior = .compress

        addBar(bar, dataSource: self, at: .custom(view: tabContentView, layout: nil))
    }
}

extension TeamInfoViewController: PageboyViewControllerDataSource, TMBarDataSource {
    public func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "개발팀")
        case 1:
            return TMBarItem(title: "주간 왁뮤팀")
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
