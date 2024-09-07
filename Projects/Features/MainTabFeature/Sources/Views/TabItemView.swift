//
//  TabItemView.swift
//  MainTabFeature
//
//  Created by KTH on 2023/01/13.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DesignSystem
import LogManager
import Lottie
import SnapKit
import UIKit
import Utility

protocol TabItemViewDelegate: AnyObject {
    func handleTap(view: TabItemView)
}

final class TabItemView: UIView {
    @IBOutlet weak var defaultTabImageView: UIImageView!
    @IBOutlet weak var lottieContentView: UIView!
    @IBOutlet weak var titleStringLabel: UILabel!

    static var newInstance: TabItemView {
        return Bundle.module.loadNibNamed(
            "TabItemView",
            owner: self,
            options: nil
        )?.first as? TabItemView ?? TabItemView()
    }

    weak var delegate: TabItemViewDelegate?

    private var lottieAnimationView: LottieAnimationView?

    var isSelected: Bool = false {
        didSet {
            self.updateUI(isSelected: isSelected)
        }
    }

    var item: TabItem? {
        didSet {
            self.configure(self.item)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTapGesture()
    }
}

private extension TabItemView {
    func animateLottie() {
        guard let item = self.item else { return }

        if self.lottieAnimationView == nil {
            self.lottieAnimationView = LottieAnimationView(
                name: item.animateImage,
                bundle: DesignSystemResources.bundle
            )

            guard let lottieAnimationView = self.lottieAnimationView else { return }

            lottieAnimationView.frame = self.lottieContentView.bounds
            lottieAnimationView.backgroundColor = .clear
            lottieAnimationView.contentMode = .scaleAspectFill
            lottieAnimationView.loopMode = .playOnce

            self.lottieContentView.addSubview(lottieAnimationView)

            lottieAnimationView.snp.makeConstraints {
                $0.width.height.equalTo(32)
                $0.centerX.equalTo(self.lottieContentView.snp.centerX)
                $0.centerY.equalTo(self.lottieContentView.snp.centerY).offset(0.75)
            }

            self.lottieContentView.isHidden = false
            self.defaultTabImageView.isHidden = !self.lottieContentView.isHidden

            lottieAnimationView.stop()
            lottieAnimationView.play { _ in
            }

        } else {
            guard let lottieAnimationView = self.lottieAnimationView else { return }
            self.lottieContentView.isHidden = false
            self.defaultTabImageView.isHidden = !self.lottieContentView.isHidden

            lottieAnimationView.stop()
            lottieAnimationView.play { _ in
            }
        }
    }

    func updateUI(isSelected: Bool) {
        self.titleStringLabel.textColor = isSelected ?
            DesignSystemAsset.BlueGrayColor.gray900.color : DesignSystemAsset.BlueGrayColor.gray400.color
        self.defaultTabImageView.image = isSelected ? item?.onImage : item?.offImage

        if isSelected {
            animateLottie()

        } else {
            self.defaultTabImageView.isHidden = false
            self.lottieContentView.isHidden = true
        }
    }

    func configure(_ item: TabItem?) {
        guard let model = item else { return }

        let attributedString = NSMutableAttributedString(
            string: model.title,
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.medium.font(size: 12),
                .foregroundColor: DesignSystemAsset.BlueGrayColor.gray900.color,
                .kern: -0.5
            ]
        )
        self.titleStringLabel.attributedText = attributedString
        self.defaultTabImageView.image = model.offImage
        self.isSelected = model.isSelected
    }

    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleGesture(_:))
        )
        self.addGestureRecognizer(tapGesture)
    }

    @objc
    func handleGesture(_ sender: UITapGestureRecognizer) {
        self.delegate?.handleTap(view: self)
        if let item {
            let log = MainTabAnalyticsLog.clickTabbarTab(tab: item.analyticsTabbarType)
            LogManager.analytics(log)
        }
    }
}

final class TabItem {
    var title: String
    var offImage: UIImage
    var onImage: UIImage
    var animateImage: String
    var isSelected: Bool
    let analyticsTabbarType: MainTabAnalyticsLog.TabbarTab

    public init(
        title: String,
        offImage: UIImage,
        onImage: UIImage,
        animateImage: String,
        isSelected: Bool = false,
        analyticsTabbarType: MainTabAnalyticsLog.TabbarTab
    ) {
        self.title = title
        self.offImage = offImage
        self.onImage = onImage
        self.animateImage = animateImage
        self.isSelected = isSelected
        self.analyticsTabbarType = analyticsTabbarType
    }
}
