//
//  ArtistListCell.swift
//  WaktaverseMusic
//
//  Created by KTH on 2022/12/15.
//

import UIKit
import Kingfisher
import Utility
import DomainModule

class ArtistListCell: UICollectionViewCell {

    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
}

extension ArtistListCell {

    func update(model: ArtistListEntity) {

        self.contentView.alpha = model.isHiddenItem ? 0 : 1

        artistLabel.text = model.name
//        artistImageView.image = model.image
    }
}
