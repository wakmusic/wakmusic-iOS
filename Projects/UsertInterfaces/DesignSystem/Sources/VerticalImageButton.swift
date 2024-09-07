//
//  VerticalImageButton.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/03/20.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import SnapKit
import UIKit

internal class VerticalImageButton: UIView {
    let imageView = UIImageView()
    let titleLabel = UILabel()

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(imageView)
        addSubview(titleLabel)

        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(4)
            $0.width.height.equalTo(32)
        }

        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
