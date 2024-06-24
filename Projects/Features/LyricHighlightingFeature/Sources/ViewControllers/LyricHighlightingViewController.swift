import DesignSystem
import LogManager
import NVActivityIndicatorView
import RxCocoa
import RxSwift
import UIKit
import Utility

public final class LyricHighlightingViewController: UIViewController {
    private let navigationBarView = UIView()

    let backButton = UIButton(type: .system).then {
        $0.tintColor = .white
        $0.setImage(DesignSystemAsset.Navigation.back.image, for: .normal)
    }

    private let dimmedBackgroundView = UIView()

    private let navigationTitleStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
    }

    let songLabel = UILabel().then {
        $0.textColor = DesignSystemAsset.BlueGrayColor.gray25.color
        $0.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
    }

    let artistLabel = UILabel().then {
        $0.textColor = DesignSystemAsset.BlueGrayColor.gray100.color.withAlphaComponent(0.6)
        $0.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
    }

    private let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 10
        $0.minimumInteritemSpacing = 10
        $0.sectionInset = .init(top: 16, left: 0, bottom: 28, right: 0)
    }

    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewFlowLayout
    ).then {
        $0.backgroundColor = .clear
    }

    let emptyLabel = UILabel().then {
        $0.text = "가사가 없습니다."
        $0.textColor = .white
        $0.font = DesignSystemFontFamily.Pretendard.light.font(size: 18)
        $0.setTextWithAttributes(alignment: .center)
        $0.isHidden = true
    }

    let completeButton = UIButton().then {
        $0.layer.borderColor = DesignSystemAsset.PrimaryColorV2.point.color.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(DesignSystemAsset.PrimaryColorV2.point.color, for: .normal)
        $0.titleLabel?.font = DesignSystemFontFamily.Pretendard.bold.font(size: 12)
        $0.titleLabel?.setTextWithAttributes(alignment: .center)
        $0.isHidden = true
    }

    let indicator = NVActivityIndicatorView(frame: .zero).then {
        $0.type = .circleStrokeSpin
        $0.color = DesignSystemAsset.PrimaryColorV2.point.color
    }

    private var dimmedLayer: DimmedGradientLayer?
    var lyricDecoratingComponent: LyricDecoratingComponent

    private var viewModel: LyricHighlightingViewModel
    lazy var input = LyricHighlightingViewModel.Input()
    lazy var output = viewModel.transform(from: input)
    let disposeBag = DisposeBag()

    deinit {
        LogManager.printDebug("❌:: \(Self.self) deinit")
    }

    public init(
        viewModel: LyricHighlightingViewModel,
        lyricDecoratingComponent: LyricDecoratingComponent
    ) {
        self.viewModel = viewModel
        self.lyricDecoratingComponent = lyricDecoratingComponent
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("\(Self.self) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setAutoLayout()
        configureUI()
        outputBind()
        inputBind()
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if dimmedLayer == nil {
            let dimmedLayer = DimmedGradientLayer(frame: dimmedBackgroundView.bounds)
            self.dimmedLayer = dimmedLayer
            dimmedBackgroundView.layer.addSublayer(dimmedLayer)
        }
    }
}

private extension LyricHighlightingViewController {
    func addSubViews() {
        view.addSubviews(
            dimmedBackgroundView,
            navigationBarView,
            collectionView,
            emptyLabel,
            indicator
        )
        navigationBarView.addSubviews(backButton, navigationTitleStackView, completeButton)
        navigationTitleStackView.addArrangedSubview(songLabel)
        navigationTitleStackView.addArrangedSubview(artistLabel)
    }

    func setAutoLayout() {
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48)
        }

        backButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(32)
        }

        completeButton.snp.makeConstraints {
            $0.width.equalTo(45)
            $0.height.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
        }

        navigationTitleStackView.snp.makeConstraints {
            $0.leading.equalTo(backButton.snp.trailing).offset(10+13)
            $0.trailing.equalTo(completeButton.snp.leading).offset(-10)
            $0.centerY.equalToSuperview()
        }

        songLabel.snp.makeConstraints {
            $0.height.equalTo(24)
        }

        artistLabel.snp.makeConstraints {
            $0.height.equalTo(20)
        }

        dimmedBackgroundView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(collectionView)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        indicator.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(30)
        }
    }

    func configureUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = .white
        collectionView.register(LyricHighlightingCell.self, forCellWithReuseIdentifier: "\(LyricHighlightingCell.self)")
        indicator.startAnimating()
    }
}

extension LyricHighlightingViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return LyricHighlightingCell.cellHeight(entity: output.dataSource.value[indexPath.item])
    }
}

extension LyricHighlightingViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
