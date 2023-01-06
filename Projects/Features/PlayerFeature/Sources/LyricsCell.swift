//
//  LyricsCell.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/01/06.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit

class LyricsCell: UITableViewCell {

    @IBOutlet weak var lyricsLabel: CustomLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
