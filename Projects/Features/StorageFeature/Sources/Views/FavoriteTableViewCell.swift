//
//  FavoriteTableViewCell.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/27.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import CommonFeature
import DesignSystem
import SongsDomainInterface
import UIKit
import UserDomainInterface
import Utility

public protocol FavoriteTableViewCellDelegate: AnyObject {
    func buttonTapped(type: FavoriteTableViewCellDelegateConstant)
}

public enum FavoriteTableViewCellDelegateConstant {
    case listTapped(indexPath: IndexPath)
    case playTapped(song: SongEntity)
}

class FavoriteTableViewCell: UITableViewCell {
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playButtonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var listSelectButton: UIButton!

    @IBAction func playButtonAction(_ sender: UIButton) {
        guard let song = self.passToModel.1 else { return }
        delegate?.buttonTapped(type: .playTapped(song: song))
    }

    @IBAction func listSelectButtonAction(_ sender: Any) {
        delegate?.buttonTapped(type: .listTapped(indexPath: passToModel.0))
    }

    weak var delegate: FavoriteTableViewCellDelegate?
    var passToModel: (IndexPath, SongEntity?) = (IndexPath(row: 0, section: 0), nil)

    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = .clear
        self.albumImageView.layer.cornerRadius = 4
        self.titleLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        self.artistLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        self.titleLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        self.artistLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        playButton.setImage(DesignSystemAsset.Storage.play.image, for: .normal)
    }
}

extension FavoriteTableViewCell {
    func update(model: FavoriteSongEntity, isEditing: Bool, indexPath: IndexPath) {
        self.passToModel = (indexPath, model.song)

        self.albumImageView.kf.setImage(
            with: WMImageAPI.fetchYoutubeThumbnail(id: model.song.id).toURL,
            placeholder: DesignSystemAsset.Logo.placeHolderSmall.image,
            options: [.transition(.fade(0.2))]
        )
        self.titleLabel.text = model.song.title
        self.artistLabel.text = model.song.artist

        self.backgroundColor = model.isSelected ? DesignSystemAsset.GrayColor.gray200.color : UIColor.clear
        self.listSelectButton.isHidden = !isEditing
        self.playButton.isHidden = isEditing
        self.playButtonTrailingConstraint.constant = isEditing ? -24 : 20
    }
}
