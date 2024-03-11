//
//  MyPlayListTableViewCell.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/27.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DesignSystem
import Kingfisher
import UIKit
import UserDomainInterface
import Utility

public protocol MyPlayListTableViewCellDelegate: AnyObject {
    func buttonTapped(type: MyPlayListTableViewCellDelegateConstant)
}

public enum MyPlayListTableViewCellDelegateConstant {
    case listTapped(indexPath: IndexPath)
    case playTapped(indexPath: IndexPath)
}

class MyPlayListTableViewCell: UITableViewCell {
    @IBOutlet weak var playListImageView: UIImageView!
    @IBOutlet weak var playListNameLabel: UILabel!
    @IBOutlet weak var playListCountLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playButtonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var listSelectButton: UIButton!

    @IBAction func playButtonAction(_ sender: UIButton) {
        delegate?.buttonTapped(type: .playTapped(indexPath: passToModel.0))
    }

    @IBAction func listSelectButtonAction(_ sender: Any) {
        delegate?.buttonTapped(type: .listTapped(indexPath: passToModel.0))
    }

    weak var delegate: MyPlayListTableViewCellDelegate?
    var passToModel: (IndexPath, String) = (IndexPath(row: 0, section: 0), "")

    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = .clear
        self.playListImageView.layer.cornerRadius = 4
        self.playButton.setImage(DesignSystemAsset.Storage.play.image, for: .normal)
    }
}

extension MyPlayListTableViewCell {
    func update(model: PlayListEntity, isEditing: Bool, indexPath: IndexPath) {
        self.passToModel = (indexPath, model.key)

        self.playListImageView.kf.setImage(
            with: WMImageAPI.fetchPlayList(id: String(model.image), version: model.image_version).toURL,
            placeholder: nil,
            options: [.transition(.fade(0.2))]
        )

        self.playListNameLabel.attributedText = getAttributedString(
            text: model.title,
            font: DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        )

        self.playListCountLabel.attributedText = getAttributedString(
            text: "\(model.songlist.count)곡",
            font: DesignSystemFontFamily.Pretendard.light.font(size: 12)
        )

        self.backgroundColor = model.isSelected ? DesignSystemAsset.GrayColor.gray200.color : UIColor.clear
        self.listSelectButton.isHidden = !isEditing
        self.playButton.isHidden = isEditing
        self.playButtonTrailingConstraint.constant = isEditing ? -24 : 20
    }

    private func getAttributedString(
        text: String,
        font: UIFont
    ) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(
            string: text,
            attributes: [
                .font: font,
                .foregroundColor: DesignSystemAsset.GrayColor.gray900.color,
                .kern: -0.5
            ]
        )
        return attributedString
    }
}
