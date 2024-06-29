import BaseFeatureInterface
import DesignSystem
import FruitDrawFeatureInterface
import LogManager
import NVActivityIndicatorView
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit
import Utility
import  UserDomainInterface

public final class FruitStorageViewController: UIViewController {
    private let gradientLayer = CAGradientLayer()

    private let navigationBarView = WMNavigationBarView()

    private let backButton = UIButton(type: .system).then {
        let dismissImage = DesignSystemAsset.Navigation.back.image
            .withTintColor(DesignSystemAsset.PrimaryColorV2.white.color, renderingMode: .alwaysOriginal)
        $0.setImage(dismissImage, for: .normal)
        $0.tintColor = .white
    }

    private let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 32.0.correctTop
        $0.minimumInteritemSpacing = 0
        $0.sectionInset = .init(top: 24, left: 0, bottom: 40, right: 0)
    }

    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewFlowLayout
    ).then {
        $0.backgroundColor = .clear
    }

    private lazy var activityIndicator = NVActivityIndicatorView(frame: .zero).then {
        $0.color = .white
        $0.type = .circleStrokeSpin
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
    func outputBind() {
        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        output.fruitSource
            .skip(1)
            .do(onNext: { [activityIndicator] _ in
                activityIndicator.stopAnimating()
            })
            .bind(to: collectionView.rx.items) { [weak self] collectionView, index, model in
                guard let self = self else { return UICollectionViewCell() }
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "\(FruitListCell.self)",
                    for: IndexPath(item: index, section: 0)
                ) as? FruitListCell else {
                    return UICollectionViewCell()
                }
                cell.update(model: model)
                cell.delegate = self
                return cell
            }
            .disposed(by: disposeBag)
    }

    func inputBind() {
        input.fetchFruitList.onNext(())

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
            navigationBarView,
            collectionView,
            activityIndicator
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

        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(30)
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
        collectionView.register(FruitListCell.self, forCellWithReuseIdentifier: "\(FruitListCell.self)")
        collectionView.contentInset = .init(top: 0, left: 0, bottom: PLAYER_HEIGHT(), right: 0)
        activityIndicator.startAnimating()
    }
}

extension FruitStorageViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width: CGFloat = APP_WIDTH()
        let height: CGFloat = (collectionView.frame.height - 24 - 40 - (32.0.correctTop * 4)) / 5
        return .init(width: width, height: height)
    }
}

extension FruitStorageViewController: FruitListCellDelegate {
    public func itemSelected(item: FruitEntity) {
        LogManager.printDebug(item)
    }
}
