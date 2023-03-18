//
//  HomeMainTitleTableViewCell.swift
//  HomeFeature
//
//  Created by Fo co on 2023/03/18.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit

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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
