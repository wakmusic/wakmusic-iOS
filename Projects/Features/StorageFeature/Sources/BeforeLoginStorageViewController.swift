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

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var fakeView: UIView!
    
    @IBOutlet weak var appLogoImageView: UIImageView!
    
    @IBOutlet weak var appNameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var naverLoginButton: UIButton!
    @IBOutlet weak var naverImageVIew: UIImageView!
    @IBOutlet weak var naverSuperView: UIView!
    

    
    @IBOutlet weak var googleImageView: UIImageView!
    @IBOutlet weak var googleSuperView: UIView!
    @IBOutlet weak var googleLoginButton: UIButton!

    
    @IBOutlet weak var appleImageView: UIImageView!
    @IBOutlet weak var appleSuperView: UIView!
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
        
        
        let superViewArr:[UIView] = [naverSuperView,googleSuperView,appleSuperView]
        
        
        for sv in superViewArr {
            sv.layer.cornerRadius = 12
            sv.layer.borderColor = DesignSystemAsset.GrayColor.gray200.color.withAlphaComponent(0.4).cgColor
            sv.layer.borderWidth = 3
        }
        
        
        naverImageVIew.image = DesignSystemAsset.Signup.naver.image
        naverLoginButton.setAttributedTitle(loginAttributedString[0], for: .normal)
       
        
        
        googleImageView.image = DesignSystemAsset.Signup.google.image
        googleLoginButton.setAttributedTitle(loginAttributedString[1], for: .normal)
        
       
        appleImageView.image = DesignSystemAsset.Signup.apple.image
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
        versionLabel.text = "버전정보 \(APP_VERSION())"
        
    
        
        
        
        
    }
    
}
