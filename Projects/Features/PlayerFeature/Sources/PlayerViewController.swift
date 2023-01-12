//
//  PlayerViewController.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/01/09.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import SwiftUI
import Utility
import DesignSystem
import SnapKit
import Then

public class PlayerViewController: UIViewController {
    var playerView: PlayerView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        bindUI()
    }
    
    public override func loadView() {
        super.loadView()
        
        playerView = PlayerView(frame: self.view.frame)
        //self.view = playerView
        self.view.addSubview(playerView)
    }
}

public extension PlayerViewController {
    func updateOpacity(value: Float) {
        playerView.layer.opacity = value
    }
}

private extension PlayerViewController {
    private func bindViewModel() {
    }
    
    private func bindUI() {
    }
}

struct NewPlayerViewController_Previews: PreviewProvider {
    static var previews: some View {
        PlayerViewController().toPreview()
    }
}
