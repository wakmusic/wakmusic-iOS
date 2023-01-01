//
//  HomeViewController.swift
//  RootFeature
//
//  Created by KTH on 2023/01/01.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import DesignSystem

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let imageView = UIImageView(frame: CGRect(x: 100, y: 100, width: 50, height: 50))
        let image = DesignSystemAsset.TabBar.homeOn.image
        imageView.image = image
        self.view.addSubview(imageView)
    }
}
