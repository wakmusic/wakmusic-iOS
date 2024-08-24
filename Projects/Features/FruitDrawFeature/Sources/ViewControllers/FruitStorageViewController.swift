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
import UserDomainInterface
import Utility

public final class FruitStorageViewController: UIViewController {
    private let gradientLayer = CAGradientLayer()

    private let navigationBarView = WMNavigationBarView()

    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))

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
    private let textPopupFactory: TextPopupFactory

    lazy var input = FruitStorageViewModel.Input()
    lazy var output = viewModel.transform(from: input)
    private let disposeBag = DisposeBag()

    deinit {
        LogManager.printDebug("❌:: \(Self.self) deinit")
    }

    public init(
        viewModel: FruitStorageViewModel,
        textPopupFactory: TextPopupFactory
    ) {
        self.viewModel = viewModel
        self.textPopupFactory = textPopupFactory
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

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LogManager.analytics(FruitDrawAnalyticsLog.viewPage(pageName: "fruit_storage"))
        NotificationCenter.default.post(name: .willStatusBarEnterDarkBackground, object: nil)
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: .willStatusBarEnterLightBackground, object: nil)
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gradientLayer.frame = CGRect(
            x: view.bounds.origin.x,
            y: view.bounds.origin.y,
            width: view.bounds.width,
            height: view.bounds.height + PLAYER_HEIGHT() + SAFEAREA_BOTTOM_HEIGHT()
        )
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
                cell.update(
                    model: model,
                    floor: index,
                    totalCount: self.output.fruitTotalCount.value
                )
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
            collectionView,
            visualEffectView,
            navigationBarView,
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

        visualEffectView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(navigationBarView.snp.bottom)
        }

        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
        collectionView.contentInset = .init(top: 48, left: 0, bottom: 0, right: 0)
        collectionView.showsVerticalScrollIndicator = false
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
        let height: CGFloat = (
            collectionView.frame.height
                - 24 - 40 - STATUS_BAR_HEGHIT() - 48 - (32.0.correctTop * 4)
        ) / 5
        return .init(width: width, height: height)
    }
}

extension FruitStorageViewController: FruitListCellDelegate {
    public func itemSelected(item: FruitEntity) {
        LogManager.analytics(FruitDrawAnalyticsLog.clickFruitItem(id: item.fruitID))
        let viewController = FruitInfoPopupViewController(item: item)
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        present(viewController, animated: true)
    }
}

extension FruitStorageViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.1) {
            self.visualEffectView.alpha = scrollView.contentOffset.y > -(STATUS_BAR_HEGHIT() + 48) ? 1 : 0
        }
    }
}
