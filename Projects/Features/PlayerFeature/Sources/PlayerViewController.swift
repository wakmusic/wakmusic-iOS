//
//  PlayerViewController.swift
//  RootFeatureTests
//
//  Created by KTH on 2023/01/02.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem

class PlayerViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var titleLabel: CustomLabel!
    @IBOutlet weak var artistLabel: CustomLabel!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var backgroundBlurImageView: UIImageView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var currentPlayTimeLabel: CustomLabel!
    @IBOutlet weak var totalPlayTimeLabel: CustomLabel!
    
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var viewsView: UIView!
    @IBOutlet weak var addPlaylistButton: UIButton!
    @IBOutlet weak var playlistButton: UIButton!
    
    
    var titleString: String = ""
    var artistString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    @IBAction func closeButtonAction(_ sender: Any) {
    }
    
    
    
    public static func viewController() -> PlayerViewController {
        let viewController = PlayerViewController.viewController(storyBoardName: "Player", bundle: Bundle.module)
        return viewController
    }
}

extension PlayerViewController {

    private func configureUI() {
        backgroundBlurImageView.layer.opacity = 0.6
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView()
        blurEffectView.frame = backgroundBlurImageView.frame
        //blurEffectView.frame = CGRect(x: 0, y: 0, width: backgroundBlurImageView.frame.width, height: backgroundBlurImageView.fra)
        blurEffectView.center = backgroundBlurImageView.center
        self.backgroundBlurImageView.addSubview(blurEffectView)
    }
}
