//
//  PlayListDetailViewController.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/15.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility

class PlayListDetailViewController: UIViewController,ViewControllerFromStoryBoard {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    public static func viewController() -> PlayListDetailViewController {
        let viewController = PlayListDetailViewController.viewController(storyBoardName: "Search", bundle: Bundle.module)
        return viewController
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
