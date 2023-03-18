//
//  SongsActionViewController.swift
//  CommonFeature
//
//  Created by KTH on 2023/03/13.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem

public class SongCartViewController: UIViewController, ViewControllerFromStoryBoard {

    public override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    public static func viewController() -> SongCartViewController {
        let viewController = SongCartViewController.viewController(storyBoardName: "CommonUI", bundle: Bundle.module)
        return viewController
    }
}
