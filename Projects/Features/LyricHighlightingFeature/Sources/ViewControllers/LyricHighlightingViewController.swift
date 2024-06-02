//
//  LyricHighlightingViewController.swift
//  LyricHighlightingFeature
//
//  Created by KTH on 6/1/24.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import DesignSystem
import LogManager
import RxCocoa
import RxSwift
import UIKit
import Utility

open class LyricHighlightingViewController: UIViewController {
    private let navigationBarView = UIView()

    private let backButton = UIButton(type: .system).then {
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
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 10
        $0.minimumInteritemSpacing = 10
        $0.sectionInset = .init(top: 0, left: 20, bottom: 0, right: 20)
    }

    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewFlowLayout
    ).then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
    }

    private let saveButtonContentView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.NewGrayColor.gray900.color
    }

    private let singleLineLabel = UILabel().then {
        $0.backgroundColor = DesignSystemAsset.NewGrayColor.gray700.color
    }

    private let saveButton = UIButton().then {
        $0.setImage(DesignSystemAsset.LyricHighlighting.lyricHighlightSaveOff.image, for: .normal)
        $0.setImage(DesignSystemAsset.LyricHighlighting.lyricHighlightSaveOn.image, for: .selected)
    }

    private var dimmedLayer: DimmedGradientLayer?

    deinit {
        LogManager.printDebug("❌:: \(Self.self) deinit")
    }

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("\(Self.self) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        addSubViews()
        setAutoLayout()
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
    }

    func configureUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = .white
    }
}
