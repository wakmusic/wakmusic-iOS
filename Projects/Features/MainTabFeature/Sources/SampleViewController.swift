//
//  SampleViewController.swift
//  MainTabFeature
//
//  Created by KTH on 2023/01/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem
import Lottie

public class SampleViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var homeTabImageView: UIImageView!
    @IBOutlet weak var chartTabImageView: UIImageView!
    @IBOutlet weak var searchTabImageView: UIImageView!
    @IBOutlet weak var artistTabImageView: UIImageView!
    @IBOutlet weak var storageTabImageView: UIImageView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
    
    public static func viewController() -> SampleViewController {
        let viewController = SampleViewController.viewController(storyBoardName: "Main", bundle: Bundle.module)
        return viewController
    }
}

extension SampleViewController {
    
    private func configure() {
        
        homeTabImageView.image = DesignSystemAsset.TabBar.homeOn.image
        chartTabImageView.image = DesignSystemAsset.TabBar.chartOn.image
        searchTabImageView.image = DesignSystemAsset.TabBar.searchOn.image
        artistTabImageView.image = DesignSystemAsset.TabBar.artistOn.image
        storageTabImageView.image = DesignSystemAsset.TabBar.storageOn.image
        
        
        [homeTabImageView,
         chartTabImageView,
         searchTabImageView,
         artistTabImageView,
         storageTabImageView].enumerated().forEach { (i, view) in
            var name: String = ""
            
            if i == 0 {
                name = "Home_Tab"
            }else if i == 1 {
                name = "Chart_Tab"
            }else if i == 2 {
                name = "Search_Tab"
            }else if i == 3 {
                name = "Artist_Tab"
            }else if i == 4 {
                name = "Storage_Tab"
            }
            
            let animationView = LottieAnimationView(name: name, bundle: DesignSystemResources.bundle)
            animationView.frame = view?.bounds ?? .zero
            DEBUG_LOG(view?.bounds ?? .zero)
            animationView.backgroundColor = .clear
            animationView.contentMode = .scaleAspectFill
            animationView.loopMode = .loop
            view?.addSubview(animationView)
            animationView.play()
            
        }
    }
}
