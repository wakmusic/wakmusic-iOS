//
//  ArtistDetailHeaderViewController.swift
//  ArtistFeature
//
//  Created by KTH on 2023/01/21.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem

class ArtistDetailHeaderViewController: UIViewController, ViewControllerFromStoryBoard {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    public static func viewController() -> ArtistDetailHeaderViewController {
        let viewController = ArtistDetailHeaderViewController.viewController(storyBoardName: "Artist", bundle: Bundle.module)
        return viewController
    }

}
