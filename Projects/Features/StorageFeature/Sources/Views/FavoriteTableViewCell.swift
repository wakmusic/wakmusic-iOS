//
//  FavoriteTableViewCell.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/27.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import DesignSystem
import CommonFeature
import DomainModule
import Utility

public protocol FavoriteTableViewCellDelegate: AnyObject {
    func listTapped(indexPath: IndexPath)
}

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playButtonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var listSelectButton: UIButton!
    
    @IBAction func playButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func listSelectButtonAction(_ sender: Any) {
        DEBUG_LOG("weufweuojweogi")
        delegate?.listTapped(indexPath: self.indexPath)
    }
    
    weak var delegate: FavoriteTableViewCellDelegate?
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)

    override var isEditing: Bool {
        didSet {
            updatePlayingState()
        }
    }

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
        self.albumImageView.kf.setImage(
            with: WMImageAPI.fetchYoutubeThumbnail(id: model.song.id).toURL,
            placeholder: DesignSystemAsset.Logo.placeHolderSmall.image,
            options: [.transition(.fade(0.2))]
        )
        self.titleLabel.text =  model.song.title
        self.artistLabel.text = model.song.artist
        
        self.backgroundColor = model.isSelected ? DesignSystemAsset.GrayColor.gray200.color : UIColor.clear
        self.isEditing = isEditing
        self.listSelectButton.isHidden = !isEditing
        self.indexPath = indexPath
    }
    
    private func updatePlayingState() {
        if self.isEditing {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in // 오른쪽으로 사라지는 애니메이션
                guard let self else { return }
                self.playButton.alpha = 0
                self.playButton.transform = CGAffineTransform(translationX: 100, y: 0)
                self.playButtonTrailingConstraint.constant = -24
                self.layoutIfNeeded()

            }, completion: { [weak self] _ in
                guard let `self` = self else { return }
                self.playButton.isHidden = true
            })
        } else {
            self.playButton.isHidden = false
            UIView.animate(withDuration: 0.3, animations: { [weak self] in // 다시 나타나는 애니메이ㄴ
                guard let self else { return }
                self.playButton.alpha = 1
                self.playButton.transform = .identity
                self.playButton.isHidden = false
                self.playButtonTrailingConstraint.constant = 20
                self.layoutIfNeeded()

            }, completion: { _ in
            })
        }
        self.listSelectButton.isHidden = !self.isEditing
    }
}
