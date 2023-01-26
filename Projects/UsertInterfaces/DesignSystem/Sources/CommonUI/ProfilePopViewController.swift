//
//  ProfilePopViewController.swift
//  DesignSystem
//
//  Created by yongbeomkwak on 2023/01/26.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import PanModal

public final class ProfilePopViewController: UIViewController, ViewControllerFromStoryBoard {

    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    
    
    @IBAction func saveAction(_ sender: UIButton) {
        
        dismiss(animated: true)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    public static func viewController() -> ProfilePopViewController {
        let viewController = ProfilePopViewController.viewController(storyBoardName: "CommonUI", bundle: Bundle.module)
        

        
        return viewController
    }

}


extension ProfilePopViewController{
    
    private func configureUI(){
        
        saveButton.layer.cornerRadius = 12
        saveButton.clipsToBounds = true
        saveButton.setAttributedTitle(NSMutableAttributedString(string:"완료",attributes: [.font: DesignSystemFontFamily.Pretendard.medium.font(size: 18),.foregroundColor: DesignSystemAsset.GrayColor.gray25.color ]), for: .normal)
        
     
        
        
        
        
    }
    
}

extension ProfilePopViewController: PanModalPresentable {

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    public var panModalBackgroundColor: UIColor {
        return colorFromRGB(0x000000, alpha: 0.4)
    }

    public var panScrollable: UIScrollView? {
      return nil
    }

    public var longFormHeight: PanModalHeight {
    
   
        return PanModalHeight.contentHeight((APP_WIDTH() - 70) / 2 + 200 )
     }

    public var cornerRadius: CGFloat {
        return 24.0
    }

    public var allowsExtendedPanScrolling: Bool {
        return true
    }

    public var showDragIndicator: Bool {
        return false
    }
}
