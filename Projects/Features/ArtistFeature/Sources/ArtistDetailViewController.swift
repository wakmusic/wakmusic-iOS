//
//  ArtistDetailViewController.swift
//  ArtistFeature
//
//  Created by KTH on 2023/01/07.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem

class ArtistDetailViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var musicContentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let child = self.children.first as? ArtistMusicViewController else { return }
        child.view.frame = musicContentView.bounds
    }
    
    public static func viewController() -> ArtistDetailViewController {
        let viewController = ArtistDetailViewController.viewController(storyBoardName: "Artist", bundle: Bundle.module)
        return viewController
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ArtistDetailViewController {
    
    private func configureUI() {
        
        backButton.setImage(DesignSystemAsset.Navigation.back.image, for: .normal)
        
        let viewController = ArtistMusicViewController.viewController()
        self.addChild(viewController)
        self.musicContentView.addSubview(viewController.view)
        viewController.didMove(toParent: self)
        
        self.view.layoutIfNeeded()
    }
}
