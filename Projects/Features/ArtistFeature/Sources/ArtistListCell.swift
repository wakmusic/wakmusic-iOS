//
//  ArtistListCell.swift
//  WaktaverseMusic
//
//  Created by KTH on 2022/12/15.
//

import UIKit
import Kingfisher
import Utility

class ArtistListCell: UICollectionViewCell {

    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
}

extension ArtistListCell {

    func update(model: ArtistListDTO) {

        self.contentView.alpha = (model.isHiddenItem ?? false) ? 0 : 1

        artistLabel.text = model.name
        artistImageView.image = model.image
    }
}

struct ArtistListDTO {
    let name: String
    let image: UIImage
    var isHiddenItem: Bool? = false
}
