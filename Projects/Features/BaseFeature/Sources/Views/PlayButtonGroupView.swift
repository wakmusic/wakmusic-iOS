//
//  PlayButtonGroupView.swift
//  DesignSystemTests
//
//  Created by yongbeomkwak on 2023/01/18.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DesignSystem
import UIKit

public enum PlayEvent {
    case allPlay
    case shufflePlay
}

public protocol PlayButtonGroupViewDelegate: AnyObject {
    func play(_ event: PlayEvent)
}

public class PlayButtonGroupView: UIView {
    @IBOutlet weak var allPlaySuperView: UIView!
    @IBOutlet weak var allPlayButton: UIButton!

    @IBOutlet weak var shufflePlayButton: UIButton!
    @IBOutlet weak var shufflePlaySuperView: UIView!

    public weak var delegate: PlayButtonGroupViewDelegate?

    @IBAction func pressAllPlay(_ sender: UIButton) {
        delegate?.play(.allPlay)
    }

    @IBAction func pressSufflePlay(_ sender: UIButton) {
        delegate?.play(.shufflePlay)
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
}

extension PlayButtonGroupView {
    private func setupView() {
        guard let view = Bundle.module.loadNibNamed("PlayButtonGroupView", owner: self, options: nil)?.first as? UIView
        else { return }
        view.frame = self.bounds
        view.layoutIfNeeded()
        self.addSubview(view)

        view.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
        let allPlayAttributedString = NSMutableAttributedString.init(string: "전체재생")

        allPlayAttributedString.addAttributes(
            [
                .font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
                .foregroundColor: DesignSystemAsset.GrayColor.gray900.color
            ],
            range: NSRange(location: 0, length: allPlayAttributedString.string.count)
        )

        allPlaySuperView.backgroundColor = .white.withAlphaComponent(0.4)

        allPlayButton.setImage(DesignSystemAsset.Chart.allPlay.image.withRenderingMode(.alwaysOriginal), for: .normal)
        allPlayButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        allPlayButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)

        allPlaySuperView.layer.cornerRadius = 8
        allPlaySuperView.layer.borderColor = DesignSystemAsset.GrayColor.gray200.color.withAlphaComponent(0.7).cgColor
        allPlaySuperView.layer.borderWidth = 1
        allPlayButton.titleLabel?.alpha = 1

        let shufflePlayAttributedString = NSMutableAttributedString.init(string: "랜덤재생")

        shufflePlayAttributedString.addAttributes(
            [
                .font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
                .foregroundColor: DesignSystemAsset.GrayColor.gray900.color
            ],
            range: NSRange(
                location: 0,
                length: shufflePlayAttributedString.string.count
            )
        )

        shufflePlayButton.setImage(
            DesignSystemAsset.Chart.shufflePlay.image.withRenderingMode(.alwaysOriginal),
            for: .normal
        )
        shufflePlayButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        shufflePlayButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)

        shufflePlaySuperView.backgroundColor = .white.withAlphaComponent(0.4)
        shufflePlaySuperView.layer.cornerRadius = 8
        shufflePlaySuperView.layer.borderColor = DesignSystemAsset.GrayColor.gray200.color.withAlphaComponent(0.7)
            .cgColor
        shufflePlaySuperView.layer.borderWidth = 1

        // 여기 안으로 넣어보세요.
        allPlayButton.setAttributedTitle(allPlayAttributedString, for: .normal)
        shufflePlayButton.setAttributedTitle(shufflePlayAttributedString, for: .normal)
        view.layoutIfNeeded() // 당장 UI 갱신해 : 사용 이유, 버튼 텍스트 깜빡거림 방지
    }
}
