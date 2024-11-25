import BaseFeature
import DesignSystem
import Foundation
import LogManager
import NVActivityIndicatorView
import Pageboy
import RxCocoa
import RxSwift
import SnapKit
import Tabman
import TeamDomainInterface
import TeamFeatureInterface
import Then
import UIKit
import Utility

public final class TeamInfoViewController: TabmanViewController {
    private let navigationbarView = WMNavigationBarView()

    private let backButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Navigation.back.image, for: .normal)
    }

    private let tabContentView = UIView()

    private let singleLineLabel = UILabel().then {
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.gray300.color.withAlphaComponent(0.4)
    }

    private lazy var activityIndicator = NVActivityIndicatorView(frame: .zero).then {
        $0.color = DesignSystemAsset.PrimaryColorV2.point.color
        $0.type = .circleStrokeSpin
    }

    private lazy var viewControllers: [UIViewController] = {
        return []
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
    func outputBind() {
        output.dataSource
            .skip(1)
            .bind(with: self, onNext: { owner, source in
                let teams: [String] = owner.output.teams.value
                let viewControllers = teams.map { team -> TeamInfoContentViewController in
                    return TeamInfoContentViewController(
                        viewModel: .init(
                            type: TeamInfoType(rawValue: team) ?? .unknown,
                            entities: source.filter { $0.team == team }
                        )
                    )
                }
                owner.viewControllers = viewControllers
                owner.reloadData()
                owner.activityIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)
    }

    func inputBind() {
        input.fetchTeamList.onNext(())

        backButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

private extension TeamInfoViewController {
    func addSubviews() {
        view.addSubviews(navigationbarView, tabContentView, activityIndicator)
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
            $0.top.equalTo(navigationbarView.snp.bottom).offset(16 + 2)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(36 - 2)
        }

        singleLineLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }

        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(30)
        }
    }

    func configureUI() {
        view.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray100.color
        activityIndicator.startAnimating()
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

        addBar(bar, dataSource: self, at: .custom(view: tabContentView, layout: nil))
    }
}

extension TeamInfoViewController: @preconcurrency PageboyViewControllerDataSource, @preconcurrency TMBarDataSource {
    public func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return TMBarItem(title: output.teams.value[index])
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
