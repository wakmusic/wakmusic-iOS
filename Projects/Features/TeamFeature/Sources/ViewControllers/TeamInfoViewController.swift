import DesignSystem
import Foundation
import LogManager
import TeamDomainInterface
import TeamFeatureInterface
import RxSwift
import RxCocoa
import SnapKit
import Then
import UIKit
import Utility

public final class TeamInfoViewController: UIViewController {
    private let navigationbarView = WMNavigationBarView()

    private let backButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Navigation.back.image, for: .normal)
    }

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
    }
}

private extension TeamInfoViewController {
    func addSubviews() {
        view.addSubviews(navigationbarView)
        navigationbarView.setLeftViews([backButton])
        navigationbarView.setTitle("팀 소개", textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color)
    }

    func setLayout() {
        navigationbarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(48)
        }
    }

    func configureUI() {
        view.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray100.color
    }
}
