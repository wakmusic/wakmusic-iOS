//
//  MainViewController.swift
//  WaktaverseMusic
//
//  Created by Fo co on 2022/11/08.
//

import Foundation
import LGSideMenuController

class MainViewController: BaseViewController {

    @IBAction func btnActionLeft(_ sender: Any) {
        aGate.rootManager().toggleLeftViewAnimated(sender: sender)
    }

    @IBAction func btnActionRight(_ sender: Any) {
        aGate.rootManager().toggleRightViewAnimated(sender: sender)
    }
}
