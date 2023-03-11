//
//  ContainSongsViewController.swift
//  CommonFeature
//
//  Created by yongbeomkwak on 2023/03/11.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import BaseFeature
import Utility

public final class ContainSongsViewController: BaseViewController,ViewControllerFromStoryBoard{
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var songCountLabel: UILabel!
    
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    public static func viewController() -> ContainSongsViewController {
        let viewController = ContainSongsViewController.viewController(storyBoardName: "CommonUI", bundle: Bundle.module)
        
    
    
       
        return viewController
    }
    



}
