//
//  ArtistMusicContentViewController.swift
//  ArtistFeature
//
//  Created by KTH on 2023/01/07.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem

class ArtistMusicContentViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var allPlayButton: UIButton!
    @IBOutlet weak var shufflePlayButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    public static func viewController() -> ArtistMusicContentViewController {
        let viewController = ArtistMusicContentViewController.viewController(storyBoardName: "Artist", bundle: Bundle.module)
        return viewController
    }
}

extension ArtistMusicContentViewController {
    
    private func configureUI() {
        
        allPlayButton.layer.cornerRadius = 8
        allPlayButton.layer.borderColor = colorFromRGB(0xE4E7EC).cgColor
        allPlayButton.layer.borderWidth = 1
        
        shufflePlayButton.layer.cornerRadius = 8
        shufflePlayButton.layer.borderColor = colorFromRGB(0xE4E7EC).cgColor
        shufflePlayButton.layer.borderWidth = 1
    }
}
