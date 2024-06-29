import BaseFeatureInterface
import DesignSystem
import FruitDrawFeatureInterface
import LogManager
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit
import Utility

public final class FruitStorageViewController: UIViewController {
    private let gradientLayer = CAGradientLayer()

    private let navigationBarView = WMNavigationBarView()

    private let backButton = UIButton(type: .system).then {
        let dismissImage = DesignSystemAsset.Navigation.back.image
            .withTintColor(DesignSystemAsset.PrimaryColorV2.white.color, renderingMode: .alwaysOriginal)
        $0.setImage(dismissImage, for: .normal)
        $0.tintColor = .white
    }

    private let viewModel: FruitStorageViewModel
    private let textPopUpFactory: TextPopUpFactory

    lazy var input = FruitStorageViewModel.Input()
    lazy var output = viewModel.transform(from: input)
    private let disposeBag = DisposeBag()

    deinit {
        LogManager.printDebug("❌:: \(Self.self) deinit")
    }

    public init(
        viewModel: FruitStorageViewModel,
        textPopUpFactory: TextPopUpFactory
    ) {
        self.viewModel = viewModel
        self.textPopUpFactory = textPopUpFactory
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("\(Self.self) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureGradientLayer()
        addSubViews()
        setLayout()
        configureUI()
        outputBind()
        inputBind()
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gradientLayer.frame = view.bounds
    }
}

private extension FruitStorageViewController {
    func outputBind() {}

    func inputBind() {
        backButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

private extension FruitStorageViewController {
    func addSubViews() {
        view.addSubviews(
            navigationBarView
        )
        navigationBarView.setLeftViews([backButton])
        navigationBarView.setTitle("열매함", textColor: .white)
    }

    func setLayout() {
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(48)
        }
    }

    func configureGradientLayer() {
        gradientLayer.colors = [
            colorFromRGB(0x009DE6).cgColor,
            colorFromRGB(0xC585FF).cgColor,
            colorFromRGB(0xFBC6F5).cgColor,
            colorFromRGB(0xFFFFFF).cgColor
        ]
        view.layer.addSublayer(gradientLayer)
    }

    func configureUI() {
        view.backgroundColor = .white
    }
}
