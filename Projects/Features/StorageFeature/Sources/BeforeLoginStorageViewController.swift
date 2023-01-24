//
//  BeforeLoginStorageViewController.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/24.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem

class BeforeLoginStorageViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var appLogoImageView: UIImageView!
    
    @IBOutlet weak var appNameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var naverLoginButton: UIButton!
    
    @IBOutlet weak var googleLoginButton: UIButton!
    
    @IBOutlet weak var appleLoginButton: UIButton!
    
    @IBOutlet weak var serviceButton: UIButton!
    
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var versionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()

        // Do any additional setup after loading the view.
    }
    

    public static func viewController() -> BeforeLoginStorageViewController {
        let viewController = BeforeLoginStorageViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        return viewController
    }

}

extension BeforeLoginStorageViewController{
    
    private func configureUI(){
        
        appLogoImageView.image = DesignSystemAsset.Logo.applogo.image
        
        
        appNameLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 20)
        descriptionLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 14)
        
        
        var loginAttributedString:[NSMutableAttributedString] = [NSMutableAttributedString.init(string: "네이버로 로그인하기"),NSMutableAttributedString.init(string: "구글로 로그인하기"),NSMutableAttributedString.init(string: "애플로 로그인하기")]
        
        
        for attr in loginAttributedString{
            attr.addAttributes([.font: DesignSystemFontFamily.Pretendard.medium.font(size: 16),
                                .foregroundColor: DesignSystemAsset.GrayColor.gray900.color], range: NSRange(location: 0, length: attr.string.count))
        }
        
        naverLoginButton.layer.cornerRadius = 12
        naverLoginButton.layer.borderColor = DesignSystemAsset.GrayColor.gray200.color.withAlphaComponent(0.4).cgColor
        naverLoginButton.layer.borderWidth = 1
        naverLoginButton.setAttributedTitle(loginAttributedString[0], for: .normal)
        
        
        googleLoginButton.layer.cornerRadius = 12
        googleLoginButton.layer.borderColor = DesignSystemAsset.GrayColor.gray200.color.withAlphaComponent(0.4).cgColor
        googleLoginButton.layer.borderWidth = 1
        googleLoginButton.setAttributedTitle(loginAttributedString[1], for: .normal)
        
        
        appleLoginButton.layer.cornerRadius = 12
        appleLoginButton.layer.borderColor = DesignSystemAsset.GrayColor.gray200.color.withAlphaComponent(0.4).cgColor
        appleLoginButton.layer.borderWidth = 1
        appleLoginButton.setAttributedTitle(loginAttributedString[2], for: .normal)
        
        
         
        
        
        
        
        
        
        
        
        
        
        
        let serviceAttributedString = NSMutableAttributedString.init(string: "서비스 이용약관")
        
        serviceAttributedString.addAttributes([.font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
                                               .foregroundColor: DesignSystemAsset.GrayColor.gray600.color], range: NSRange(location: 0, length: serviceAttributedString.string.count))
        
        
        let privacyAttributedString = NSMutableAttributedString.init(string: "개인정보처리방침")
        
        privacyAttributedString.addAttributes([.font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
                                               .foregroundColor: DesignSystemAsset.GrayColor.gray600.color], range: NSRange(location: 0, length: privacyAttributedString.string.count))
        
        
        privacyButton.layer.cornerRadius = 8
        privacyButton.layer.borderColor = DesignSystemAsset.GrayColor.gray400.color.withAlphaComponent(0.4).cgColor
        privacyButton.layer.borderWidth = 1
        privacyButton.setAttributedTitle(privacyAttributedString, for: .normal)
        
        
        serviceButton.layer.cornerRadius = 8
        serviceButton.layer.borderColor = DesignSystemAsset.GrayColor.gray400.color.withAlphaComponent(0.4).cgColor
        serviceButton.layer.borderWidth = 1
        serviceButton.setAttributedTitle(serviceAttributedString, for: .normal)
        
        
        
        versionLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        
        
    }
    
}
