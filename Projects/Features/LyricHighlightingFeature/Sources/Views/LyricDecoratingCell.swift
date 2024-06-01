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
    var decoImageView = UIImageView().then {
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        setAutoLayout()
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
    let image: UIImage
    var isSelected: Bool
}

extension LyricDecoratingCell {
    func update(model: LyricDecoratingModel) {
        decoImageView.image = model.image
    }
}

private extension LyricDecoratingCell {
    func addSubViews() {
        contentView.addSubview(decoImageView)
    }

    func setAutoLayout() {
        decoImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
