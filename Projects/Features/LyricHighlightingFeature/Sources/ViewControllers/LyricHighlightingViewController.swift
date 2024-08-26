import DesignSystem
import Kingfisher
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

    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }

    private let dimmedBackgroundView = UIView()

    private let navigationTitleStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
    }

    let songLabel = WMFlowLabel(
        textColor: DesignSystemAsset.BlueGrayColor.gray25.color,
        font: .t5(weight: .medium),
        alignment: .center,
        kernValue: -0.5
    )

    let artistLabel = WMFlowLabel(
        textColor: DesignSystemAsset.BlueGrayColor.gray100.color.withAlphaComponent(0.6),
        font: .t6(weight: .medium),
        alignment: .center,
        kernValue: -0.5
    )

    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    ).then {
        $0.backgroundColor = .clear
    }

    let bottomContentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.isHidden = true
    }

    let writerContentView = UIView()

    let writerLabel = WMLabel(
        text: "",
        textColor: .white.withAlphaComponent(0.5),
        font: .t6(weight: .light),
        alignment: .center,
        kernValue: -0.5
    )

    let activateContentView = UIView()

    let activateTopLineLabel = UILabel().then {
        $0.backgroundColor = DesignSystemAsset.NewGrayColor.gray700.color
    }

    let activateButton = UIButton(type: .system).then {
        $0.setImage(
            DesignSystemAsset.LyricHighlighting.lyricHighlightSaveOff.image.withRenderingMode(.alwaysOriginal),
            for: .normal
        )
    }

    let warningView = UIView().then {
        $0.isHidden = true
    }

    let warningImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = DesignSystemAsset.LyricHighlighting.errorDark.image
    }

    let warningLabel = WMLabel(
        text: "노래 가사가 없습니다.",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray200.color,
        font: .t6(weight: .light),
        alignment: .center,
        lineHeight: UIFont.WMFontSystem.t6(weight: .light).lineHeight
    ).then {
        $0.numberOfLines = 0
        $0.preferredMaxLayoutWidth = APP_WIDTH() - 40
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
        $0.alpha = 0
    }

    let activityIndicator = NVActivityIndicatorView(frame: .zero).then {
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
        setLayout()
        configureUI()
        outputBind()
        inputBind()
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LogManager.analytics(
            LyricHighlightingAnalyticsLog.viewPage(pageName: "lyric_highlighting")
        )
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
            thumbnailImageView,
            dimmedBackgroundView,
            collectionView,
            bottomContentStackView,
            warningView,
            navigationBarView,
            activityIndicator
        )

        navigationBarView.addSubviews(backButton, navigationTitleStackView, completeButton)
        navigationTitleStackView.addArrangedSubview(songLabel)
        navigationTitleStackView.addArrangedSubview(artistLabel)

        bottomContentStackView.addArrangedSubviews(writerContentView, activateContentView)
        writerContentView.addSubview(writerLabel)
        activateContentView.addSubviews(activateTopLineLabel, activateButton)
        warningView.addSubviews(warningImageView, warningLabel)
    }

    func setLayout() {
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
            $0.leading.equalTo(backButton.snp.trailing).offset(10 + 13)
            $0.trailing.equalTo(completeButton.snp.leading).offset(-10)
            $0.centerY.equalToSuperview()
        }

        songLabel.snp.makeConstraints {
            $0.height.equalTo(24)
        }

        artistLabel.snp.makeConstraints {
            $0.height.equalTo(20)
        }

        thumbnailImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        dimmedBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }

        bottomContentStackView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(19)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        writerContentView.snp.makeConstraints {
            $0.height.equalTo(51)
        }

        writerLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(22)
        }

        activateContentView.snp.makeConstraints {
            $0.height.equalTo(56)
        }

        activateTopLineLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }

        activateButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        warningView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(APP_HEIGHT() * ((294.0 - 6.0) / 812.0))
            $0.centerX.equalToSuperview()
        }

        warningImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.centerX.equalToSuperview()
        }

        warningLabel.snp.makeConstraints {
            $0.top.equalTo(warningImageView.snp.bottom).offset(-2)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        activityIndicator.snp.makeConstraints {
            $0.center.equalTo(warningView.snp.center)
            $0.size.equalTo(30)
        }
    }

    func configureUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = .white
        collectionView.register(LyricHighlightingCell.self, forCellWithReuseIdentifier: "\(LyricHighlightingCell.self)")

        let alternativeSources = [
            WMImageAPI.fetchYoutubeThumbnail(id: output.updateInfo.value.songID).toURL
        ].compactMap { $0 }
            .map { Source.network($0) }
        thumbnailImageView.kf.setImage(
            with: URL(string: WMImageAPI.fetchYoutubeThumbnailHD(id: output.updateInfo.value.songID).toString),
            options: [
                .waitForCache,
                .transition(.fade(0.2)),
                .forceTransition,
                .processor(
                    DownsamplingImageProcessor(
                        size: .init(width: 10, height: 10)
                    )
                ),
                .alternativeSources(alternativeSources)
            ]
        )
        activityIndicator.startAnimating()
    }

    func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (
            sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment
        ) -> NSCollectionLayoutSection? in
            var config = UICollectionLayoutListConfiguration(appearance: .plain)
            config.showsSeparators = false
            config.backgroundColor = .clear

            let section = NSCollectionLayoutSection.list(
                using: config,
                layoutEnvironment: layoutEnvironment
            )
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 28, trailing: 0)

            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
}
