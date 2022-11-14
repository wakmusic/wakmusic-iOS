//
//  RootViewController.swift
//  WaktaverseMusic
//
//  Created by Fo co on 2022/11/11.
//

import UIKit
import LGSideMenuController

class RootViewController: LGSideMenuController {

    public var leftSide: LeftSideViewController?
    public var rightSide: RightSideViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func initView() {

        initLeftView()
        initRightView()

        let blurEffect = UIBlurEffect.init(style: .light)
        self.rootViewCoverBlurEffectForLeftView = blurEffect
        self.rootViewCoverBlurEffectForRightView = blurEffect

    }

    func initLeftView() {
        leftSide = LeftSideViewController()
        self.leftViewController = leftSide
        self.leftViewWidth = SCREENWIDTH - 45
        self.leftViewBackgroundColor = .red
        self.leftViewPresentationStyle = .slideAbove

    }

    func initRightView() {
        rightSide = RightSideViewController()
        self.rightViewController = rightSide
        self.rightViewWidth = SCREENWIDTH - 45
        self.rightViewBackgroundColor = .green
        self.rightViewPresentationStyle = .slideAbove

    }
}
