//
//  LyricHighlightingViewController.swift
//  LyricHighlightingFeature
//
//  Created by KTH on 6/1/24.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import DesignSystem
import LogManager
import NVActivityIndicatorView
import RxCocoa
import RxSwift
import UIKit
import Utility

open class LyricHighlightingViewController: UIViewController {
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

    private let songLabel = UILabel().then {
        $0.text = "리와인드 (RE:WIND)"
        $0.textColor = DesignSystemAsset.BlueGrayColor.gray25.color
        $0.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        $0.setTextWithAttributes(alignment: .center)
    }

    private let artistLabel = UILabel().then {
        $0.text = "이세계아이돌"
        $0.textColor = DesignSystemAsset.BlueGrayColor.gray100.color.withAlphaComponent(0.6)
        $0.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        $0.setTextWithAttributes(alignment: .center)
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

    let saveButtonContentView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.NewGrayColor.gray900.color
    }

    private let singleLineLabel = UILabel().then {
        $0.backgroundColor = DesignSystemAsset.NewGrayColor.gray700.color
    }

    let saveButton = UIButton().then {
        $0.setImage(DesignSystemAsset.LyricHighlighting.lyricHighlightSaveOff.image, for: .normal)
        $0.setImage(DesignSystemAsset.LyricHighlighting.lyricHighlightSaveOn.image, for: .selected)
    }

    let indicator = NVActivityIndicatorView(frame: .zero).then {
        $0.type = .circleStrokeSpin
        $0.color = DesignSystemAsset.PrimaryColorV2.point.color
    }

    private var dimmedLayer: DimmedGradientLayer?
    var lyricDecoratingComponent: LyricDecoratingComponent!

    var viewModel: LyricHighlightingViewModel!
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
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.lyricDecoratingComponent = lyricDecoratingComponent
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("\(Self.self) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setAutoLayout()
        configureUI()
        outputBind()
        inputBind()
    }

    override open func viewDidLayoutSubviews() {
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
        view.addSubview(dimmedBackgroundView)
        view.addSubview(navigationBarView)
        view.addSubview(collectionView)
        view.addSubview(saveButtonContentView)
        view.addSubview(indicator)

        navigationBarView.addSubview(backButton)
        navigationBarView.addSubview(navigationTitleStackView)

        navigationTitleStackView.addArrangedSubview(songLabel)
        navigationTitleStackView.addArrangedSubview(artistLabel)

        saveButtonContentView.addSubview(saveButton)
        saveButtonContentView.addSubview(singleLineLabel)
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

        navigationTitleStackView.snp.makeConstraints {
            $0.leading.equalTo(backButton.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-62)
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
            $0.bottom.equalTo(saveButtonContentView.snp.top)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(saveButtonContentView.snp.top)
        }

        saveButtonContentView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }

        singleLineLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }

        saveButton.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(56)
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
