//
//  CreatePlayListPopupViewController.swift
//  DesignSystem
//
//  Created by yongbeomkwak on 2023/01/21.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import PanModal
public final class  CreatePlayListPopupViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var playListTextField: UITextField!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var limitLabel: UILabel!
    @IBOutlet weak var confirmLabel: UILabel!
    
    var titleString:String = ""
    var btnString:String = ""
    
   
   
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        // Do any additional setup after loading the view.
    }
    
    public static func viewController(title:String,btnText:String) -> CreatePlayListPopupViewController {
        let viewController = CreatePlayListPopupViewController.viewController(storyBoardName: "CommonUI", bundle: Bundle.module)
        
        viewController.titleString = title
        viewController.btnString = btnText
        
        
        return viewController
    }
    



}


extension CreatePlayListPopupViewController{
    private func configureUI() {

        titleLabel.text = titleString
        titleLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 18)
        titleLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        
        
        subTitleLabel.text = "플레이리스트 제목"
        subTitleLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 16)
        subTitleLabel.textColor = DesignSystemAsset.GrayColor.gray400.color
        
        let headerFontSize:CGFloat = 20
        
        let focusedplaceHolderAttributes = [
            NSAttributedString.Key.foregroundColor: DesignSystemAsset.GrayColor.gray400.color,
            NSAttributedString.Key.font : DesignSystemFontFamily.Pretendard.medium.font(size: headerFontSize)
        ] // 포커싱 플레이스홀더 폰트 및 color 설정
        
        self.playListTextField.attributedPlaceholder = NSAttributedString(string: "검색어를 입력하세요.",attributes:focusedplaceHolderAttributes) //플레이스 홀더 설정
        self.playListTextField.font = DesignSystemFontFamily.Pretendard.medium.font(size: headerFontSize)
        
        self.dividerView.backgroundColor = DesignSystemAsset.GrayColor.gray200.color
        
        self.cancelButton.layer.cornerRadius = 12
        self.cancelButton.titleLabel?.text = "취소"
        self.cancelButton.titleLabel?.font = DesignSystemFontFamily.Pretendard.bold.font(size: 12)
        self.cancelButton.layer.cornerRadius = 4
        self.cancelButton.layer.borderColor =  DesignSystemAsset.GrayColor.gray200.color.cgColor
        self.cancelButton.layer.borderWidth = 1
        self.cancelButton.backgroundColor = .white
        
        
        self.confirmLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        self.confirmLabel.isHidden = true
        
        
        self.confirmLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        
        self.limitLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        self.limitLabel.textColor = DesignSystemAsset.GrayColor.gray500.color
        
        self.countLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        self.countLabel.textColor = DesignSystemAsset.PrimaryColor.point.color
        
        
        saveButton.setTitle(btnString, for: .normal)
        saveButton.layer.cornerRadius = 12
        saveButton.clipsToBounds = true
        saveButton.titleLabel?.font = DesignSystem.DesignSystemFontFamily.Pretendard.medium.font(size: 18)

        saveButton.setBackgroundColor(DesignSystemAsset.PrimaryColor.point.color, for: .normal)
        saveButton.setBackgroundColor(DesignSystemAsset.GrayColor.gray300.color, for: .disabled)
        
    }
    
    
    private func reactSearchHeader(_ isfocused:Bool)
    {
        
      
     
        
        
    }
}


extension CreatePlayListPopupViewController: PanModalPresentable {

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
    
   
        return PanModalHeight.contentHeight(300)
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
