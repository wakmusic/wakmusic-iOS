//
//  HomeMainTitleTableViewCell.swift
//  HomeFeature
//
//  Created by Fo co on 2023/03/18.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import SnapKit
import DesignSystem
import DomainModule
import Kingfisher
import Utility

class HomeMainTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var rankImageView: UIImageView!
    @IBOutlet weak var rankLabel: UILabel!
    
    @IBOutlet weak var titleImageView: UIImageView!
    
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var rightButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //default
        rankImageView.isHidden = true
        rankLabel.isHidden = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension HomeMainTitleTableViewCell{
    public func update(model: ChartRankingEntity, index: Int) {
        
        countLabel.text = "\(index + 1)"
        
        let lastRanking = model.last - (index + 1)
        titleImageView.kf.setImage(
            with: URL(string: WMImageAPI.fetchYoutubeThumbnail(id: model.id).toString),
            placeholder: DesignSystemAsset.Logo.placeHolderSmall.image,
            options: [.transition(.fade(0.2))]
        )
        songNameLabel.text = model.title
        artistLabel.text = model.artist
        rankLabel.text = "\(model.last)"
        rankImageView.isHidden = false
        switch (index) {
        case 0:
            rankImageView.image = DesignSystemAsset.Chart.non.image
            break
        case 1:
            rankImageView.image = DesignSystemAsset.Chart.blowup.image
            break
        case 2:
            rankImageView.image = DesignSystemAsset.Chart.up.image
            break
        case 3:
            rankImageView.image = DesignSystemAsset.Chart.down.image
            break
        default:
            break
        }

        if model.last == 0 {
            //new
            let rankLabelAttributedString = NSMutableAttributedString(
                string: "NEW",
                attributes: [.font: DesignSystemFontFamily.Pretendard.medium.font(size: 11),
                             .foregroundColor: DesignSystemAsset.PrimaryColor.new.color,
                             .kern: -0.5]
            )
            rankLabel.attributedText = rankLabelAttributedString
        } else if lastRanking > 99 {

        } else if lastRanking == 0 {
            //같음
            rankImageView.image = DesignSystemAsset.Chart.non.image
        } else if lastRanking > 0 {

        } else if lastRanking < 0 {

        }
    }

    
}
