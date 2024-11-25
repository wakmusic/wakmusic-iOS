import BaseFeature
import BaseFeatureInterface
import DesignSystem
import LogManager
import NVActivityIndicatorView
import Photos
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit
import Utility

public final class LyricDecoratingViewController: UIViewController, RequestPermissionable {
    private let navigationBarView = UIView()
    let backButton = UIButton(type: .system).then {
        $0.tintColor = DesignSystemAsset.NewGrayColor.gray900.color
        $0.setImage(DesignSystemAsset.Navigation.back.image, for: .normal)
    }

    private let navigationTitleLabel = UILabel().then {
        $0.text = "내가 선택한 가사"
        $0.textColor = DesignSystemAsset.NewGrayColor.gray900.color
        $0.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        $0.setTextWithAttributes(kernValue: -0.5, alignment: .center)
    }

    private let decorateContentView = UIView()
    let decorateShareContentView = UIView().then {
        $0.layer.cornerRadius = 32
        $0.clipsToBounds = true
    }

    let decorateImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }

    private let decorateLogoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = DesignSystemAsset.LyricHighlighting.lyricDecoratingWMLogo.image
    }

    private let decorateTextContentView = UIView().then {
        $0.backgroundColor = .clear
    }

    private let decorateFirstStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.distribution = .fill
    }

    private let decorateQuotationLeftImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = DesignSystemAsset.LyricHighlighting.lyricDecoratingQuotationMarksLeft.image
    }

    let highlightingLyricLabel = UILabel().then {
        $0.numberOfLines = 0
    }

    private let decorateQuotationRightImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = DesignSystemAsset.LyricHighlighting.lyricDecoratingQuotationMarksRight.image
    }

    private let decorateSecondStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.distribution = .fill
    }

    let songTitleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = DesignSystemFontFamily.Pretendard.light.font(size: 14)
    }

    let artistLabel = UILabel().then {
        $0.textColor = .white
        $0.font = DesignSystemFontFamily.Pretendard.light.font(size: 14)
    }

    private let decoratePickContentView = UIView().then {
        $0.backgroundColor = .clear
    }

    private let decoratePickShadowImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.image = DesignSystemAsset.LyricHighlighting.lyricDecoratingBottomShadow.image
    }

    private let descriptionLabel = UILabel().then {
        $0.text = "배경을 선택해주세요"
        $0.textColor = DesignSystemAsset.BlueGrayColor.blueGray900.color
        $0.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        $0.setTextWithAttributes(kernValue: -0.5)
    }

    private let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 4
        $0.minimumInteritemSpacing = 4
        $0.itemSize = .init(width: 56, height: 64)
        $0.sectionInset = .init(top: 0, left: 20, bottom: 0, right: 20)
    }

    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewFlowLayout
    ).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
    }

    let saveButton = UIButton(type: .system).then {
        $0.backgroundColor = DesignSystemAsset.PrimaryColorV2.point.color
        $0.setTitle("저장하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.WMFontSystem.t4(weight: .medium).font
        $0.titleLabel?.setTextWithAttributes()
        $0.isEnabled = false
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }

    let indicator = NVActivityIndicatorView(frame: .zero).then {
        $0.type = .circleStrokeSpin
        $0.color = DesignSystemAsset.PrimaryColorV2.point.color
    }

    private let viewModel: LyricDecoratingViewModel
    lazy var input = LyricDecoratingViewModel.Input()
    lazy var output = viewModel.transform(from: input)
    let textPopupFactory: TextPopupFactory
    let disposeBag = DisposeBag()

    deinit {
        LogManager.printDebug("❌:: \(Self.self) deinit")
    }

    init(
        viewModel: LyricDecoratingViewModel,
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
        addSubViews()
        setLayout()
        configureUI()
        outputBind()
        inputBind()
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LogManager.analytics(
            LyricHighlightingAnalyticsLog.viewPage(pageName: "lyric_decorating")
        )
    }
}

extension LyricDecoratingViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return .init(width: 56, height: 64)
    }
}

private extension LyricDecoratingViewController {
    func addSubViews() {
        view.addSubviews(
            navigationBarView,
            decorateContentView,
            decoratePickContentView,
            indicator
        )
        navigationBarView.addSubviews(backButton, navigationTitleLabel)

        decorateContentView.addSubview(decorateShareContentView)
        decorateShareContentView.addSubviews(decorateImageView, decorateLogoImageView, decorateTextContentView)

        decorateTextContentView.addSubview(decorateFirstStackView)
        decorateFirstStackView.addArrangedSubview(decorateQuotationLeftImageView)
        decorateFirstStackView.addArrangedSubview(highlightingLyricLabel)
        decorateFirstStackView.addArrangedSubview(decorateQuotationRightImageView)

        decorateTextContentView.addSubview(decorateSecondStackView)
        decorateSecondStackView.addArrangedSubview(songTitleLabel)
        decorateSecondStackView.addArrangedSubview(artistLabel)

        decoratePickContentView.addSubviews(decoratePickShadowImageView, descriptionLabel, collectionView, saveButton)
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

        navigationTitleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        decorateContentView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }

        decorateShareContentView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.center.equalToSuperview()
            $0.height.equalTo(decorateImageView.snp.width)
        }

        decorateImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        decorateLogoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().offset(-14)
            $0.size.equalTo(32)
        }

        decorateTextContentView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        decorateFirstStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }

        decorateQuotationLeftImageView.snp.makeConstraints {
            $0.height.equalTo(12)
        }

        decorateQuotationRightImageView.snp.makeConstraints {
            $0.height.equalTo(12)
        }

        decorateSecondStackView.snp.makeConstraints {
            $0.top.equalTo(decorateFirstStackView.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        songTitleLabel.snp.makeConstraints {
            $0.height.equalTo(22)
        }

        artistLabel.snp.makeConstraints {
            $0.height.equalTo(22)
        }

        decoratePickContentView.snp.makeConstraints {
            $0.top.equalTo(decorateContentView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        decoratePickShadowImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-24)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.snp.bottom)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(decoratePickContentView.snp.top).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(22)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(64)
        }

        saveButton.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }

        indicator.snp.makeConstraints {
            $0.center.equalTo(decorateShareContentView.snp.center)
            $0.size.equalTo(30)
        }
    }

    func configureUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = UIColor.white
        collectionView.register(LyricDecoratingCell.self, forCellWithReuseIdentifier: "\(LyricDecoratingCell.self)")
        indicator.startAnimating()
    }
}

public extension LyricDecoratingViewController {
    nonisolated func showPhotoLibrary() {
        Task { @MainActor in
            let image = decorateShareContentView.asImage(size: .init(width: 960, height: 960))
            PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            } completionHandler: { _, error in
                var message: String = ""
                if let error = error {
                    message = error.localizedDescription
                } else {
                    message = "해당 이미지가 저장되었습니다."
                }
                DispatchQueue.main.async {
                    self.showToast(text: message, options: [.tabBar])
                }
            }
        }
    }
}
