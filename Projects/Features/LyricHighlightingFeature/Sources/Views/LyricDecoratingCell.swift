//
//  LyricDecoratingCell.swift
//  ArtistFeature
//
//  Created by KTH on 2024/05/11.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import DesignSystem
import SnapKit
import Then
import UIKit

final class LyricDecoratingCell: UICollectionViewCell {
    private let decoImageView = UIImageView().then {
        $0.clipsToBounds = true
    }

    private let checkBoxContentView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray900.color.withAlphaComponent(0.4)
    }

    private let checkBoxImageView = UIImageView().then {
        $0.image = DesignSystemAsset.LyricHighlighting.lyricDecoratingCheckBox.image
    }

    private let descriptionContentView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray900.color.withAlphaComponent(0.4)
    }

    private let descriptionLabel = UILabel().then {
        $0.font = DesignSystemFontFamily.Pretendard.light.font(size: 11)
        $0.textColor = .white
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        setAutoLayout()
        layer.cornerRadius = 4
        clipsToBounds = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func prepareForReuse() {
        super.prepareForReuse()
    }
}

public struct LyricDecoratingModel {
    let imageURL: String
    let imageColor: UIColor
    var isSelected: Bool
}

extension LyricDecoratingCell {
    func update(model: LyricDecoratingModel, index: Int) {
        decoImageView.backgroundColor = model.imageColor
        descriptionLabel.text = "Color \(index + 1)"
        descriptionLabel.setTextWithAttributes(alignment: .center)
        checkBoxContentView.isHidden = !model.isSelected
    }
}

private extension LyricDecoratingCell {
    func addSubViews() {
        contentView.addSubview(decoImageView)
        contentView.addSubview(checkBoxContentView)
        contentView.addSubview(descriptionContentView)
        checkBoxContentView.addSubview(checkBoxImageView)
        descriptionContentView.addSubview(descriptionLabel)
    }

    func setAutoLayout() {
        decoImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        checkBoxContentView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        checkBoxImageView.snp.makeConstraints {
            $0.size.equalTo(32)
            $0.top.equalToSuperview().offset(8)
            $0.centerX.equalToSuperview()
        }
        descriptionContentView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(20)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(2)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(16)
        }
    }
}
