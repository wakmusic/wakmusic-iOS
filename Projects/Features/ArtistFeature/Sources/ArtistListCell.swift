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

//    func update(model: Model.ArtistList) {
//
//        self.contentView.alpha = (model.isHiddenItem ?? false) ? 0 : 1
//
//        let sideSpace: CGFloat = 8.0
//        let width: CGFloat = (APP_WIDTH() - ((sideSpace * 2.0) + 40.0)) / 3.0
//
//        bgView.layer.cornerRadius = width / 2
//        bgView.clipsToBounds = true
//        bgView.backgroundColor = colorFromRGB(model.color)
//
//        blurView.layer.cornerRadius = bgView.layer.cornerRadius
//        blurView.clipsToBounds = true
//
//        artistLabel.text = model.short
//
//        let type: String = "full"
//        let urlString: String = Router.baseURLString + "/static/artist/\(type)/\(model.id).png"
//
//        artistImageView.kf.setImage(with: URL(string: urlString), placeholder: nil,
//                                     options: [.transition(.fade(0.2))], progressBlock: nil) { (result) in
//
//            switch result {
//            case .success: break
//            case .failure: break
//            }
//        }
//    }
}
