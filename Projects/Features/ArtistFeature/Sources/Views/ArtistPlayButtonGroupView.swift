//
//  ArtistPlayButtonGroupView.swift
//  ArtistFeature
//
//  Created by KTH on 2023/04/03.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import BaseFeature
import DesignSystem
import Foundation
import UIKit
import Utility

public class ArtistPlayButtonGroupView: UIView {
    @IBOutlet weak var allPlayButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var blurEffectViews: [UIVisualEffectView]!

    public weak var delegate: PlayButtonGroupViewDelegate?

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }

    @IBAction func allPlayButtonAction(_ sender: Any) {
        delegate?.play(.allPlay)
    }
}

extension ArtistPlayButtonGroupView {
    private func setupView() {
        guard let view = Bundle.module.loadNibNamed("ArtistPlayButtonGroupView", owner: self, options: nil)?
            .first as? UIView else { return }
        view.frame = self.bounds
        view.layoutIfNeeded()
        self.addSubview(view)
        configureUI()
        layoutIfNeeded()
    }
}

extension ArtistPlayButtonGroupView {
    private func configureUI() {
        imageView.image = DesignSystemAsset.Chart.allPlay.image.withRenderingMode(.alwaysOriginal)
        // 전체재생
        allPlayButton.layer.cornerRadius = 8
        allPlayButton.layer.borderWidth = 1
        allPlayButton.layer.borderColor = DesignSystemAsset.BlueGrayColor.gray200.color.withAlphaComponent(0.7).cgColor
        allPlayButton.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        let allButtonAttributedString = NSMutableAttributedString.init(string: "전체재생")
        allButtonAttributedString.addAttributes(
            [
                .font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
                .foregroundColor: DesignSystemAsset.BlueGrayColor.gray900.color,
                .kern: -0.5
            ],
            range: NSRange(
                location: 0,
                length: allButtonAttributedString.string.count
            )
        )
        allPlayButton.setAttributedTitle(allButtonAttributedString, for: .normal)

        blurEffectViews.forEach {
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
    }
}
