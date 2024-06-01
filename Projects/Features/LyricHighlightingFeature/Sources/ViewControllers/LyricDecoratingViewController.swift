//
//  LyricDecoratingViewController.swift
//  ArtistFeature
//
//  Created by KTH on 2024/05/11.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import DesignSystem
import LogManager
import SnapKit
import Then
import UIKit
import Utility

final class LyricDecoratingViewController: UIViewController {
    private let navigationBarView = UIView()
    private let backButton = UIButton(type: .system).then {
        $0.tintColor = DesignSystemAsset.NewGrayColor.gray900.color
        $0.setImage(DesignSystemAsset.Navigation.back.image, for: .normal)
    }
    private let navigationTitleLabel = UILabel().then {
        $0.text = "내가 선택한 가사"
        $0.textColor = DesignSystemAsset.NewGrayColor.gray900.color
        $0.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        $0.setTextWithAttributes(kernValue: -0.5, alignment: .center)
    }
    private let decorateContentView = UIView().then {
        $0.backgroundColor = .clear
    }
    private let decorateImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    private let decorateBottomView = UIView().then {
        $0.backgroundColor = .clear
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
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewFlowLayout
    ).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
    }
    private let saveButton = UIButton(type: .system).then {
        $0.backgroundColor = DesignSystemAsset.PrimaryColor.point.color
        $0.setTitleColor(DesignSystemAsset.BlueGrayColor.gray25.color, for: .normal)
        $0.setTitle("저장하기", for: .normal)
        $0.titleLabel?.font = DesignSystemFontFamily.Pretendard.medium.font(size: 18)
        $0.titleLabel?.setTextWithAttributes(kernValue: -0.5, alignment: .center)
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }

    private var dataSource: [LyricDecoratingModel] = [
        .init(image: DesignSystemAsset.PlayListTheme.themeLarge0.image, isSelected: true),
        .init(image: DesignSystemAsset.PlayListTheme.themeLarge1.image, isSelected: false),
        .init(image: DesignSystemAsset.PlayListTheme.themeLarge2.image, isSelected: false),
        .init(image: DesignSystemAsset.PlayListTheme.themeLarge3.image, isSelected: false),
        .init(image: DesignSystemAsset.PlayListTheme.themeLarge4.image, isSelected: false),
        .init(image: DesignSystemAsset.PlayListTheme.themeLarge5.image, isSelected: false),
        .init(image: DesignSystemAsset.PlayListTheme.themeLarge6.image, isSelected: false),
        .init(image: DesignSystemAsset.PlayListTheme.themeLarge7.image, isSelected: false),
        .init(image: DesignSystemAsset.PlayListTheme.themeLarge8.image, isSelected: false),
        .init(image: DesignSystemAsset.PlayListTheme.themeLarge9.image, isSelected: false)
    ]

    deinit {
        LogManager.printDebug("❌:: \(Self.self) deinit")
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("\(Self.self) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        addSubViews()
        setAutoLayout()
        configureCollectionView()
    }
}

extension LyricDecoratingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let i = dataSource.firstIndex(where: { $0.isSelected }),
            i != indexPath.item else {
            return
        }
        dataSource[i].isSelected = false
        dataSource[indexPath.item].isSelected = true
        decorateImageView.image = dataSource[indexPath.item].image
        collectionView.reloadData()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return dataSource.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "\(LyricDecoratingCell.self)",
            for: indexPath
        ) as? LyricDecoratingCell else {
            return UICollectionViewCell()
        }
        cell.update(model: dataSource[indexPath.item])
        return cell
    }
}

private extension LyricDecoratingViewController {
    func addSubViews() {
        view.addSubview(navigationBarView)
        navigationBarView.addSubview(backButton)
        navigationBarView.addSubview(navigationTitleLabel)

        view.addSubview(decorateContentView)
        decorateContentView.addSubview(decorateImageView)

        view.addSubview(decorateBottomView)
        decorateBottomView.addSubview(descriptionLabel)
        decorateBottomView.addSubview(collectionView)
        decorateBottomView.addSubview(saveButton)
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
        navigationTitleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        decorateContentView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(decorateBottomView.snp.top)
        }
        decorateImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.center.equalToSuperview()
            $0.height.equalTo(decorateImageView.snp.width)
        }
        decorateBottomView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(206)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(decorateBottomView.snp.top).offset(16)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(22)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(64)
        }
        saveButton.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(56)
        }
    }

    func configureUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = UIColor.white
        decorateImageView.image = dataSource.first?.image
    }

    func configureCollectionView() {
        collectionView.register(LyricDecoratingCell.self, forCellWithReuseIdentifier: "\(LyricDecoratingCell.self)")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}
